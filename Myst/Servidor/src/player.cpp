////////////////////////////////////////////////////////////////////////
// OpenTibia - an opensource roleplaying game
////////////////////////////////////////////////////////////////////////
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
////////////////////////////////////////////////////////////////////////
#include "otpch.h"
#include <iostream>

#include "player.h"
#include "iologindata.h"
#include "ioban.h"

#include "town.h"
#include "house.h"
#include "beds.h"

#include "combat.h"
#if defined(WINDOWS) && !defined(__CONSOLE__)
#include "gui.h"
#endif

#include "movement.h"
#include "weapons.h"
#include "creatureevent.h"

#include "configmanager.h"
#include "game.h"
#include "chat.h"

extern ConfigManager g_config;
extern Game g_game;
extern Chat g_chat;
extern MoveEvents* g_moveEvents;
extern Weapons* g_weapons;
extern CreatureEvents* g_creatureEvents;

AutoList<Player> Player::autoList;
#ifdef __ENABLE_SERVER_DIAGNOSTIC__
uint32_t Player::playerCount = 0;
#endif
MuteCountMap Player::muteCountMap;

Player::Player(const std::string& _name, ProtocolGame* p):
	Creature(), transferContainer(ITEM_LOCKER), name(_name), nameDescription(_name), client(p)
{
	if(client)
		client->setPlayer(this);

	pzLocked = isConnecting = addAttackSkillPoint = requestedOutfit = false;
	saving = true;

	pokeballsCount = 0;

	// Thalles Vitor - Auto Loot
	lootEnabled = false;

	// Thalles Vitor - Online System
	status = "data/images/game/status/online.png";

	lastAttackBlockType = BLOCK_NONE;
	chaseMode = CHASEMODE_STANDSTILL;
	fightMode = FIGHTMODE_ATTACK;
	tradeState = TRADE_NONE;
	accountManager = MANAGER_NONE;
	guildLevel = GUILDLEVEL_NONE;

	promotionLevel = walkTaskEvent = actionTaskEvent = nextStepEvent = bloodHitCount = shieldBlockCount = 0;
	lastAttack = idleTime = marriage = blessings = balance = premiumDays = mana = manaMax = manaSpent = 0;
	soul = guildId = levelPercent = magLevelPercent = magLevel = experience = damageImmunities = 0;
	conditionImmunities = conditionSuppressions = groupId = vocation_id = managerNumber2 = town = skullEnd = 0;
	lastLogin = lastLogout = lastIP = messageTicks = messageBuffer = nextAction = 0;
	editListId = maxWriteLen = windowTextId = rankId = 0;

	purchaseCallback = saleCallback = -1;
	level = shootRange = 1;
	rates[SKILL__MAGLEVEL] = rates[SKILL__LEVEL] = 1.0f;
	soulMax = 100;
	capacity = 400.00;
	stamina = STAMINA_MAX;
	lastLoad = lastPing = lastPong = OTSYS_TIME();

	writeItem = NULL;
	group = NULL;
	editHouse = NULL;
	shopOwner = NULL;
	tradeItem = NULL;
	tradePartner = NULL;
	walkTask = NULL;

	setVocation(0);
	setParty(NULL);

	transferContainer.setParent(NULL);
	for(int32_t i = 0; i < 14; i++)
	{
		if (i <= 13) {
			inventory[i] = NULL;
		}
	}

	for(int32_t i = SKILL_FIRST; i <= SKILL_LAST; ++i)
	{
		skills[i][SKILL_LEVEL] = 10;
		skills[i][SKILL_TRIES] = skills[i][SKILL_PERCENT] = 0;
		rates[i] = 1.0f;
	}

	for(int32_t i = SKILL_FIRST; i <= SKILL_LAST; ++i)
		varSkills[i] = 0;

	for(int32_t i = STAT_FIRST; i <= STAT_LAST; ++i)
		varStats[i] = 0;

	for(int32_t i = LOSS_FIRST; i <= LOSS_LAST; ++i)
		lossPercent[i] = 100;

#ifdef __ENABLE_SERVER_DIAGNOSTIC__

	playerCount++;
#endif
}

Player::~Player()
{
#ifdef __ENABLE_SERVER_DIAGNOSTIC__
	playerCount--;
#endif
	setWriteItem(NULL);
	for (int32_t i = 0; i < 14; i++)
	{
		if (inventory[i]) {
			inventory[i]->setParent(NULL);
			inventory[i]->unRef();

			inventory[i] = NULL;
		}
	}

	setNextWalkActionTask(NULL);
	transferContainer.setParent(NULL);
	for(DepotMap::iterator it = depots.begin(); it != depots.end(); it++)
		it->second.first->unRef();
}

int8_t Player::pokemonCountIn(const Item* item) const{
	int32_t count = 0;
	boost::any value = item->getAttribute("poke");
	if (value.type() == typeid(std::string))
		count += 1;

	const Container* container = item->getContainer();
	if (container){
		if (container->getID() == 28146)
			return 0;

		for (ContainerIterator it = container->begin(), end = container->end(); it != end; ++it)
		{
			boost::any value = (*it)->getAttribute("poke");
			if (value.type() == typeid(std::string)){
				count += 1;
			}
		}
	}
	return count;
}

int8_t Player::getPokemonCount() const{
	if (pokeballsCount < 0)
		return 0;
	return pokeballsCount;
}

bool Player::excededPokemonsLimit(int8_t n) const{
	int32_t limit = 6;
	if (getPokemonCount() + n > limit)
		return true;

	return false;
}


void Player::setVocation(uint32_t vocId)
{
	vocation_id = vocId;
	vocation = Vocations::getInstance()->getVocation(vocId);

	soulMax = vocation->getGain(GAIN_SOUL);
	if(Condition* condition = getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT))
	{
		condition->setParam(CONDITIONPARAM_HEALTHGAIN, vocation->getGainAmount(GAIN_HEALTH));
		condition->setParam(CONDITIONPARAM_HEALTHTICKS, (vocation->getGainTicks(GAIN_HEALTH) * 1000));
		condition->setParam(CONDITIONPARAM_MANAGAIN, vocation->getGainAmount(GAIN_MANA));
		condition->setParam(CONDITIONPARAM_MANATICKS, (vocation->getGainTicks(GAIN_MANA) * 1000));
	}
}

bool Player::isPushable() const
{
	return accountManager == MANAGER_NONE && !hasFlag(PlayerFlag_CannotBePushed) && Creature::isPushable();
}

std::string Player::getDescription(int32_t lookDistance) const
{
	std::stringstream s;
	if(lookDistance == -1)
	{
		s << "yourself.";
		if(hasFlag(PlayerFlag_ShowGroupNameInsteadOfVocation))
			s << " You are " << group->getName();
		else if(vocation_id != 0)
			s << " You are " << vocation->getDescription();
		else
			s << " You have no vocation";
	}
	else
	{
		s << nameDescription;
		if(!hasCustomFlag(PlayerCustomFlag_HideLevel))
			s << " (Level " << level << ")";

		s << ". " << (sex % 2 ? "He" : "She");
		if(hasFlag(PlayerFlag_ShowGroupNameInsteadOfVocation))
			s << " is " << group->getName();
		else if(vocation_id != 0)
			s << " is " << vocation->getDescription();
		else
			s << " has no vocation";

		s << getSpecialDescription();
	}

	std::string tmp;
	if(marriage && IOLoginData::getInstance()->getNameByGuid(marriage, tmp))
	{
		s << ", ";
		if(vocation_id == 0)
		{
			if(lookDistance == -1)
				s << "and you are";
			else
				s << "and is";

			s << " ";
		}

		s << (sex % 2 ? "husband" : "wife") << " of " << tmp;
	}

	s << ".";
	if(guildId)
	{
		if(lookDistance == -1)
			s << " You are ";
		else
			s << " " << (sex % 2 ? "He" : "She") << " is ";

		s << (rankName.empty() ? "a member" : rankName)<< " of the " << guildName;
		if(!guildNick.empty())
			s << " (" << guildNick << ")";

		s << ".";
	}

	return s.str();
}

Item* Player::getInventoryItem(slots_t slot) const
{
	if(slot > SLOT_PRE_FIRST && slot <= 13)
		return inventory[slot];

	if(slot == SLOT_HAND)
		return inventory[SLOT_LEFT] ? inventory[SLOT_LEFT] : inventory[SLOT_RIGHT];

	return NULL;
}

Item* Player::getEquippedItem(slots_t slot) const
{
	Item* item = getInventoryItem(slot);
	if(!item)
		return NULL;

	switch(slot)
	{
		case SLOT_LEFT:
		case SLOT_RIGHT:
			return item->getWieldPosition() == SLOT_HAND ? item : NULL;

		default:
			break;
	}

	return item->getWieldPosition() == slot ? item : NULL;
}

void Player::setConditionSuppressions(uint32_t conditions, bool remove)
{
	if(!remove)
		conditionSuppressions |= conditions;
	else
		conditionSuppressions &= ~conditions;
}

Item* Player::getWeapon(bool ignoreAmmo /*= false*/)
{
	Item* item;
	for(uint32_t slot = SLOT_RIGHT; slot <= SLOT_LEFT; slot++)
	{
		item = getEquippedItem((slots_t)slot);
		if(!item)
			continue;

		switch(item->getWeaponType())
		{
			case WEAPON_SWORD:
			case WEAPON_AXE:
			case WEAPON_CLUB:
			case WEAPON_WAND:
			case WEAPON_FIST:
			{
				const Weapon* weapon = g_weapons->getWeapon(item);
				if(weapon)
					return item;
				break;
			}

			case WEAPON_DIST:
			{
				if(!ignoreAmmo && item->getAmmoType() != AMMO_NONE)
				{
					Item* ammoItem = getInventoryItem(SLOT_AMMO);
					if(ammoItem && ammoItem->getAmmoType() == item->getAmmoType())
					{
						const Weapon* weapon = g_weapons->getWeapon(ammoItem);
						if(weapon)
						{
							shootRange = item->getShootRange();
							return ammoItem;
						}
					}
				}
				else
				{
					const Weapon* weapon = g_weapons->getWeapon(item);
					if(weapon)
					{
						shootRange = item->getShootRange();
						return item;
					}
				}
				break;
			}

			default:
				break;
		}
	}

	return NULL;
}

WeaponType_t Player::getWeaponType()
{
	if(Item* item = getWeapon())
		return item->getWeaponType();

	return WEAPON_NONE;
}

int32_t Player::getWeaponSkill(const Item* item) const
{
	if(!item)
		return getSkill(SKILL_FIST, SKILL_LEVEL);

	switch(item->getWeaponType())
	{
		case WEAPON_SWORD:
			return getSkill(SKILL_SWORD, SKILL_LEVEL);

		case WEAPON_CLUB:
			return getSkill(SKILL_CLUB, SKILL_LEVEL);

		case WEAPON_AXE:
			return getSkill(SKILL_AXE, SKILL_LEVEL);

		case WEAPON_FIST:
			return getSkill(SKILL_FIST, SKILL_LEVEL);

		case WEAPON_DIST:
			return getSkill(SKILL_DIST, SKILL_LEVEL);

		default:
			break;
	}

	return 0;
}

int32_t Player::getArmor() const
{
	int32_t armor = 0;
	for(int32_t i = SLOT_FIRST; i < SLOT_LAST; ++i)
	{
		if (i == 11 || i == 12)
			continue;

		if(Item* item = getInventoryItem((slots_t)i))
			armor += item->getArmor();
	}

	if(vocation->getMultiplier(MULTIPLIER_ARMOR) != 1.0)
		return int32_t(armor * vocation->getMultiplier(MULTIPLIER_ARMOR));

	return armor;
}

void Player::getShieldAndWeapon(const Item* &shield, const Item* &weapon) const
{
	shield = weapon = NULL;

	Item* item = NULL;
	for(uint32_t slot = SLOT_RIGHT; slot <= SLOT_LEFT; slot++)
	{
		item = getInventoryItem((slots_t)slot);
		if(!item)
			continue;

		switch(item->getWeaponType())
		{
			case WEAPON_NONE:
				break;

			case WEAPON_SHIELD:
			{
				if(!shield || (shield && item->getDefense() > shield->getDefense()))
					shield = item;

				break;
			}

			default: //weapons that are not shields
			{
				weapon = item;
				break;
			}
		}
	}
}

int32_t Player::getDefense() const
{
	int32_t baseDefense = 5, defenseValue = 0, defenseSkill = 0, extraDefense = 0;
	float defenseFactor = getDefenseFactor();

	const Item* weapon = NULL;
	const Item* shield = NULL;

	getShieldAndWeapon(shield, weapon);
	if(weapon)
	{
		extraDefense = weapon->getExtraDefense();
		defenseValue = baseDefense + weapon->getDefense();
		defenseSkill = getWeaponSkill(weapon);
	}

	if(shield && shield->getDefense() > defenseValue)
	{
		if(shield->getExtraDefense() > extraDefense)
			extraDefense = shield->getExtraDefense();

		defenseValue = baseDefense + shield->getDefense();
		defenseSkill = getSkill(SKILL_SHIELD, SKILL_LEVEL);
	}

	if(!defenseSkill)
		return 0;

	defenseValue += extraDefense;
	if(vocation->getMultiplier(MULTIPLIER_DEFENSE) != 1.0)
		defenseValue = int32_t(defenseValue * vocation->getMultiplier(MULTIPLIER_DEFENSE));

	return ((int32_t)std::ceil(((float)(defenseSkill * (defenseValue * 0.015)) + (defenseValue * 0.1)) * defenseFactor));
}

float Player::getAttackFactor() const
{
	switch(fightMode)
	{
		case FIGHTMODE_BALANCED:
			return 1.2f;

		case FIGHTMODE_DEFENSE:
			return 2.0f;

		case FIGHTMODE_ATTACK:
		default:
			break;
	}

	return 1.0f;
}

float Player::getDefenseFactor() const
{
	switch(fightMode)
	{
		case FIGHTMODE_BALANCED:
			return 1.2f;

		case FIGHTMODE_DEFENSE:
		{
			if((OTSYS_TIME() - lastAttack) < const_cast<Player*>(this)->getAttackSpeed()) //attacking will cause us to get into normal defense
				return 1.0f;

			return 2.0f;
		}

		case FIGHTMODE_ATTACK:
		default:
			break;
	}

	return 1.0f;
}

void Player::sendIcons() const
{
	if(!client)
		return;

	uint32_t icons = 0;
	for(ConditionList::const_iterator it = conditions.begin(); it != conditions.end(); ++it)
	{
		if(!isSuppress((*it)->getType()))
			icons |= (*it)->getIcons();
	}

	if(getZone() == ZONE_PROTECTION)
		icons |= ICON_PROTECTIONZONE;

	if(pzLocked)
		icons |= ICON_PZ;

	client->sendIcons(icons);
}

int8_t Player::pokemonCountInSlot(const Item* item) const{
	int32_t count = 0;
	boost::any value = item->getAttribute("poke");
	if (value.type() == typeid(std::string))
		count += 1;

	return count;
}

void Player::updateInventoryWeight()
{
	pokeballsCount = 0;
	for (int32_t i = SLOT_FIRST; i < SLOT_LAST; ++i)
	{
		if (i == 13)
			continue;

		if (i == 1)
			continue;

		if (Item* item = getInventoryItem((slots_t)i)){
			if (item->getContainer())
				pokeballsCount += pokemonCountIn(item);

			pokeballsCount += pokemonCountInSlot(item);
		}
	}

	mana = pokeballsCount;
}

void Player::updateInventoryGoods(uint32_t itemId)
{
	if(Item::items[itemId].worth)
	{
		sendGoods();
		return;
	}

	for(ShopInfoList::iterator it = shopOffer.begin(); it != shopOffer.end(); ++it)
	{
		if(it->itemId != itemId)
			continue;

		sendGoods();
		break;
	}
}

int32_t Player::getPlayerInfo(playerinfo_t playerinfo) const
{
	switch(playerinfo)
	{
		case PLAYERINFO_LEVEL:
			return level;
		case PLAYERINFO_LEVELPERCENT:
			return levelPercent;
		case PLAYERINFO_MAGICLEVEL:
			return std::max((int32_t)0, ((int32_t)magLevel + varStats[STAT_MAGICLEVEL]));
		case PLAYERINFO_MAGICLEVELPERCENT:
			return magLevelPercent;
		case PLAYERINFO_HEALTH:
			return health;
		case PLAYERINFO_MAXHEALTH:
			return std::max((int32_t)1, ((int32_t)healthMax + varStats[STAT_MAXHEALTH]));
		case PLAYERINFO_MANA:
			return mana;
		case PLAYERINFO_MAXMANA:
			return std::max((int32_t)0, ((int32_t)manaMax + varStats[STAT_MAXMANA]));
		case PLAYERINFO_SOUL:
			return std::max((int32_t)0, ((int32_t)soul + varStats[STAT_SOUL]));
		default:
			break;
	}

	return 0;
}

int32_t Player::getSkill(skills_t skilltype, skillsid_t skillinfo) const
{
	int32_t ret = skills[skilltype][skillinfo];
	if(skillinfo == SKILL_LEVEL)
		ret += varSkills[skilltype];

	return std::max((int32_t)0, ret);
}

void Player::addSkillAdvance(skills_t skill, uint32_t count, bool useMultiplier/* = true*/)
{
	if(!count)
		return;

	//player has reached max skill
	uint32_t currReqTries = vocation->getReqSkillTries(skill, skills[skill][SKILL_LEVEL]),
		nextReqTries = vocation->getReqSkillTries(skill, skills[skill][SKILL_LEVEL] + 1);
	if(currReqTries > nextReqTries)
		return;

	if(useMultiplier)
		count = uint32_t((double)count * rates[skill] * g_config.getDouble(ConfigManager::RATE_SKILL));

	std::stringstream s;
	while(skills[skill][SKILL_TRIES] + count >= nextReqTries)
	{
		count -= nextReqTries - skills[skill][SKILL_TRIES];
	 	skills[skill][SKILL_TRIES] = skills[skill][SKILL_PERCENT] = 0;
		skills[skill][SKILL_LEVEL]++;

		s.str("");
		s << "Voce avancou em " << getSkillName(skill);
		if(g_config.getBool(ConfigManager::ADVANCING_SKILL_LEVEL))
			s << " [" << skills[skill][SKILL_LEVEL] << "]";

		s << ".";
		sendTextMessage(MSG_EVENT_ADVANCE, s.str().c_str());

		CreatureEventList advanceEvents = getCreatureEvents(CREATURE_EVENT_ADVANCE);
		for(CreatureEventList::iterator it = advanceEvents.begin(); it != advanceEvents.end(); ++it)
			(*it)->executeAdvance(this, skill, (skills[skill][SKILL_LEVEL] - 1), skills[skill][SKILL_LEVEL]);

		currReqTries = nextReqTries;
		nextReqTries = vocation->getReqSkillTries(skill, skills[skill][SKILL_LEVEL] + 1);
		if(currReqTries > nextReqTries)
		{
			count = 0;
			break;
		}
	}

	if(count)
		skills[skill][SKILL_TRIES] += count;

	//update percent
	if (skill == 6) {
		uint32_t newPercent = Player::getPercentLevel(skills[skill][SKILL_TRIES], nextReqTries);
		if(skills[skill][SKILL_PERCENT] != newPercent)
		{
			skills[skill][SKILL_PERCENT] = newPercent;
			sendSkills();
		}
		else if(!s.str().empty())
			sendSkills();
	}
	else {
		uint32_t newPercent = Player::getPercentLevel(skills[skill][SKILL_TRIES], nextReqTries);
		if(skills[skill][SKILL_PERCENT] != newPercent)
		{
			skills[skill][SKILL_PERCENT] = newPercent;
			sendSkills();
		}
		else if(!s.str().empty())
			sendSkills();
	}
}

void Player::setVarStats(stats_t stat, int32_t modifier)
{
	varStats[stat] += modifier;
	switch(stat)
	{
		case STAT_MAXHEALTH:
		{
			if(getHealth() > getMaxHealth())
				Creature::changeHealth(getMaxHealth() - getHealth());
			else
				g_game.addCreatureHealth(this);

			break;
		}

		case STAT_MAXMANA:
		{
			if(getMana() > getMaxMana())
				Creature::changeMana(getMaxMana() - getMana());

			break;
		}

		default:
			break;
	}
}

int32_t Player::getDefaultStats(stats_t stat)
{
	switch(stat)
	{
		case STAT_MAGICLEVEL:
			return getMagicLevel() - getVarStats(STAT_MAGICLEVEL);
		case STAT_MAXHEALTH:
			return getMaxHealth() - getVarStats(STAT_MAXHEALTH);
		case STAT_MAXMANA:
			return getMaxMana() - getVarStats(STAT_MAXMANA);
		case STAT_SOUL:
			return getSoul() - getVarStats(STAT_SOUL);
		default:
			break;
	}

	return 0;
}

Container* Player::getContainer(uint32_t cid)
{
	for(ContainerVector::iterator it = containerVec.begin(); it != containerVec.end(); ++it)
	{
		if(it->first == cid)
			return it->second;
	}

	return NULL;
}

int32_t Player::getContainerID(const Container* container) const
{
	for(ContainerVector::const_iterator cl = containerVec.begin(); cl != containerVec.end(); ++cl)
	{
		if(cl->second == container)
			return cl->first;
	}

	return -1;
}

void Player::addContainer(uint32_t cid, Container* container)
{
#ifdef __DEBUG__
	std::cout << getName() << ", addContainer: " << (int32_t)cid << std::endl;
#endif
	if(cid > 0xF)
		return;

	for(ContainerVector::iterator cl = containerVec.begin(); cl != containerVec.end(); ++cl)
	{
		if(cl->first == cid)
		{
			cl->second = container;
			return;
		}
	}

	containerVec.push_back(std::make_pair(cid, container));
}

void Player::closeContainer(uint32_t cid)
{
	for(ContainerVector::iterator cl = containerVec.begin(); cl != containerVec.end(); ++cl)
	{
		if(cl->first == cid)
		{
			containerVec.erase(cl);
			break;
		}
	}
#ifdef __DEBUG__

	std::cout << getName() << ", closeContainer: " << (int32_t)cid << std::endl;
#endif
}

bool Player::canOpenCorpse(uint32_t ownerId)
{
	return getID() == ownerId || (party && party->canOpenCorpse(ownerId)) || hasCustomFlag(PlayerCustomFlag_GamemasterPrivileges);
}

uint16_t Player::getLookCorpse() const
{
	if(sex % 2)
		return ITEM_MALE_CORPSE;

	return ITEM_FEMALE_CORPSE;
}

void Player::dropLoot(Container* corpse)
{
	if(!corpse || lootDrop != LOOT_DROP_FULL)
		return;

	uint32_t start = g_config.getNumber(ConfigManager::BLESS_REDUCTION_BASE), loss = lossPercent[LOSS_CONTAINERS], bless = getBlessings();
	while(bless > 0 && loss > 0)
	{
		loss -= start;
		start -= g_config.getNumber(ConfigManager::BLESS_REDUCTION_DECREAMENT);
		bless--;
	}
}

bool Player::setStorage(const uint32_t key, const std::string& value)
{
	if(!IS_IN_KEYRANGE(key, RESERVED_RANGE))
		return Creature::setStorage(key, value);

	if(IS_IN_KEYRANGE(key, OUTFITS_RANGE))
	{
		uint32_t lookType = atoi(value.c_str()) >> 16;
		uint32_t addons = atoi(value.c_str()) & 0xFF;
		if(addons < 4)
		{
			Outfit outfit;
			if(Outfits::getInstance()->getOutfit(lookType, outfit))
				return addOutfit(outfit.outfitId, addons);
		}
		else
			std::cout << "[Warning - Player::setStorage] Invalid addons value key: " << key
				<< ", value: " << value << " for player: " << getName() << std::endl;
	}
	else if(IS_IN_KEYRANGE(key, OUTFITSID_RANGE))
	{
		uint32_t outfitId = atoi(value.c_str()) >> 16;
		uint32_t addons = atoi(value.c_str()) & 0xFF;
		if(addons < 4)
			return addOutfit(outfitId, addons);
		else
			std::cout << "[Warning - Player::setStorage] Invalid addons value key: " << key
				<< ", value: " << value << " for player: " << getName() << std::endl;
	}
	else
		std::cout << "[Warning - Player::setStorage] Unknown reserved key: " << key << " for player: " << getName() << std::endl;

	return false;
}

void Player::eraseStorage(const uint32_t key)
{
	Creature::eraseStorage(key);
	if(IS_IN_KEYRANGE(key, RESERVED_RANGE))
		std::cout << "[Warning - Player::eraseStorage] Unknown reserved key: " << key << " for player: " << name << std::endl;
}

bool Player::canSee(const Position& pos) const
{
	if(client)
		return client->canSee(pos);

	return false;
}

bool Player::canSeeCreature(const Creature* creature) const
{
	if(creature == this)
		return true;

	if(const Player* player = creature->getPlayer())
		return !player->isGhost() || getGhostAccess() >= player->getGhostAccess();

	return !creature->isInvisible() || canSeeInvisibility();
}

bool Player::canWalkthrough(const Creature* creature) const
{
	if (creature) {
		const Monster* monster = creature->getMonster();
		if (monster && !monster->isSummon())
			return false;

		if (monster && monster->isSummon())
			return true;

		const Player* player = creature->getPlayer();
		if(!player)
			return true;
		
		if (player && player->isGhost())
			return false;

		if (player && player->groupId >= 5)
			return false;

		if (player) {
			std::string fly;
			getStorage(17000, fly);

			if (atoi(fly.c_str()) >= 1)
				return false;

			std::string ride;
			getStorage(17001, ride);

			if (atoi(ride.c_str()) >= 1)
				return false;

			std::string surf;
			getStorage(63215, surf);

			if (atoi(surf.c_str()) >= 1)
				return false;

			return true;
		}
	}
 
    return true;
}

Depot* Player::getDepot(uint32_t depotId, bool autoCreateDepot)
{
	DepotMap::iterator it = depots.find(depotId);
	if(it != depots.end())
		return it->second.first;

	//create a new depot?
	if(autoCreateDepot)
	{
		Item* locker = Item::CreateItem(ITEM_LOCKER);
		if(Container* container = locker->getContainer())
		{
			if(Depot* depot = container->getDepot())
			{
				container->__internalAddThing(Item::CreateItem(ITEM_DEPOT));
				addDepot(depot, depotId);
				return depot;
			}
		}

		g_game.freeThing(locker);
		std::cout << "Failure: Creating a new depot with id: " << depotId <<
			", for player: " << getName() << std::endl;
	}

	return NULL;
}

/* bool Player::addDepot(Depot* depot, uint32_t depotId)
{
	if(getDepot(depotId, false))
		return false;

	depots[depotId] = std::make_pair(depot, false);
	depot->setMaxDepotLimit((group != NULL ? group->getDepotLimit(isPremium()) : 1000));
	return true;
} */

bool Player::addDepot(Depot* depot, uint32_t depotId)
{
    if(getDepot(depotId, false))
        return false;

    depots[depotId] = std::make_pair(depot, false);
    depot->setMaxDepotLimit((group != NULL ? group->getDepotLimit(isPremium()) : 1000));

    if(depotId == 3)
        depot->setMaxSizeDepot(1);
    return true;
}

void Player::useDepot(uint32_t depotId, bool value)
{
	DepotMap::iterator it = depots.find(depotId);
	if(it != depots.end())
		depots[depotId] = std::make_pair(it->second.first, value);
}

void Player::sendCancelMessage(ReturnValue message) const
{
	switch(message)
	{
		case RET_DESTINATIONOUTOFREACH:
			sendCancel("Destination is out of reach.");
			break;

		case RET_NOTMOVEABLE:
			sendCancel("You cannot move this object.");
			break;

		case RET_DROPTWOHANDEDITEM:
			sendCancel("Drop the double-handed object first.");
			break;

		case RET_BOTHHANDSNEEDTOBEFREE:
			sendCancel("Both hands needs to be free.");
			break;

		case RET_CANNOTBEDRESSED:
			sendCancel("You cannot dress this object there.");
			break;

		case RET_PUTTHISOBJECTINYOURHAND:
			sendCancel("Put this object in your hand.");
			break;

		case RET_PUTTHISOBJECTINBOTHHANDS:
			sendCancel("Put this object in both hands.");
			break;

		case RET_CANONLYUSEONEWEAPON:
			sendCancel("You may use only one weapon.");
			break;

		case RET_TOOFARAWAY:
			sendCancel("Too far away.");
			break;

		case RET_FIRSTGODOWNSTAIRS:
			sendCancel("First go downstairs.");
			break;

		case RET_FIRSTGOUPSTAIRS:
			sendCancel("First go upstairs.");
			break;

		case RET_NOTENOUGHCAPACITY:
			sendCancel("You can't carry more than 6 pokemons.");
			break;

		case RET_CONTAINERNOTENOUGHROOM:
			sendCancel("You cannot put more objects in this container.");
			break;

		case RET_NEEDEXCHANGE:
		case RET_NOTENOUGHROOM:
			sendCancel("There is not enough room.");
			break;

		case RET_CANNOTPICKUP:
			sendCancel("You cannot pickup this object.");
			break;

		case RET_CANNOTTHROW:
			sendCancel("You cannot throw there.");
			break;

		case RET_THEREISNOWAY:
			sendCancel("There is no way.");
			break;

		case RET_THISISIMPOSSIBLE:
			sendCancel("This is impossible.");
			break;

		case RET_PLAYERISPZLOCKED:
			sendCancel("You cannot enter a protection zone after attacking another player.");
			break;

		case RET_PLAYERISNOTINVITED:
			sendCancel("You are not invited.");
			break;

		case RET_CREATUREDOESNOTEXIST:
			sendCancel("Creature does not exist.");
			break;

		case RET_DEPOTISFULL:
			sendCancel("You cannot put more items in this depot.");
			break;

		case RET_CANNOTUSETHISOBJECT:
			sendCancel("You cannot use this object.");
			break;

		case RET_PLAYERWITHTHISNAMEISNOTONLINE:
			sendCancel("A player with this name is not online.");
			break;

		case RET_NOTREQUIREDLEVELTOUSERUNE:
			sendCancel("You do not have the required magic level to use this rune.");
			break;

		case RET_YOUAREALREADYTRADING:
			sendCancel("You are already trading.");
			break;

		case RET_THISPLAYERISALREADYTRADING:
			sendCancel("This player is already trading.");
			break;

		case RET_YOUMAYNOTLOGOUTDURINGAFIGHT:
			sendCancel("You may not logout during or immediately after a fight!");
			break;

		case RET_DIRECTPLAYERSHOOT:
			sendCancel("You are not allowed to shoot directly on players.");
			break;

		case RET_NOTENOUGHLEVEL:
			sendCancel("You do not have enough level.");
			break;

		case RET_NOTENOUGHMAGICLEVEL:
			sendCancel("You do not have enough magic level.");
			break;

		case RET_NOTENOUGHMANA:
			sendCancel("You do not have enough mana.");
			break;

		case RET_NOTENOUGHSOUL:
			sendCancel("You do not have enough soul.");
			break;

		case RET_YOUAREEXHAUSTED:
			sendCancel("You are exhausted.");
			break;

		case RET_CANONLYUSETHISRUNEONCREATURES:
			sendCancel("You can only use this rune on creatures.");
			break;

		case RET_PLAYERISNOTREACHABLE:
			sendCancel("Player is not reachable.");
			break;

		case RET_CREATUREISNOTREACHABLE:
			sendCancel("Creature is not reachable.");
			break;

		case RET_ACTIONNOTPERMITTEDINPROTECTIONZONE:
			sendCancel("This action is not permitted in a protection zone.");
			break;

		case RET_YOUMAYNOTATTACKTHISPLAYER:
			sendCancel("You may not attack this player.");
			break;

		case RET_YOUMAYNOTATTACKTHISCREATURE:
			sendCancel("You may not attack this creature.");
			break;

		case RET_YOUMAYNOTATTACKAPERSONINPROTECTIONZONE:
			sendCancel("You may not attack a person in a protection zone.");
			break;

		case RET_YOUMAYNOTATTACKAPERSONWHILEINPROTECTIONZONE:
			sendCancel("You may not attack a person while you are in a protection zone.");
			break;

		case RET_YOUCANONLYUSEITONCREATURES:
			sendCancel("You can only use it on creatures.");
			break;

		case RET_TURNSECUREMODETOATTACKUNMARKEDPLAYERS:
			sendCancel("Turn secure mode off if you really want to attack unmarked players.");
			break;

		case RET_YOUNEEDPREMIUMACCOUNT:
			sendCancel("You need a premium account.");
			break;

		case RET_YOUNEEDTOLEARNTHISSPELL:
			sendCancel("You need to learn this spell first.");
			break;

		case RET_YOURVOCATIONCANNOTUSETHISSPELL:
			sendCancel("Your vocation cannot use this spell.");
			break;

		case RET_YOUNEEDAWEAPONTOUSETHISSPELL:
			sendCancel("You need to equip a weapon to use this spell.");
			break;

		case RET_PLAYERISPZLOCKEDLEAVEPVPZONE:
			sendCancel("You cannot leave a pvp zone after attacking another player.");
			break;

		case RET_PLAYERISPZLOCKEDENTERPVPZONE:
			sendCancel("You cannot enter a pvp zone after attacking another player.");
			break;

		case RET_ACTIONNOTPERMITTEDINANOPVPZONE:
			sendCancel("This action is not permitted in a non-pvp zone.");
			break;

		case RET_YOUCANNOTLOGOUTHERE:
			sendCancel("You cannot logout here.");
			break;

		case RET_YOUNEEDAMAGICITEMTOCASTSPELL:
			sendCancel("You need a magic item to cast this spell.");
			break;

		case RET_CANNOTCONJUREITEMHERE:
			sendCancel("You cannot conjure items here.");
			break;

		case RET_YOUNEEDTOSPLITYOURSPEARS:
			sendCancel("You need to split your spears first.");
			break;

		case RET_NAMEISTOOAMBIGUOUS:
			sendCancel("Name is too ambiguous.");
			break;

		case RET_CANONLYUSEONESHIELD:
			sendCancel("You may use only one shield.");
			break;

		case RET_YOUARENOTTHEOWNER:
			sendCancel("You are not the owner.");
			break;

		case RET_YOUMAYNOTCASTAREAONBLACKSKULL:
			sendCancel("You may not cast area spells while you have a black skull.");
			break;

		case RET_TILEISFULL:
			sendCancel("You cannot add more items on this tile.");
			break;

		case RET_DONTSHOWMESSAGE:
			break;

		case RET_NOTPOSSIBLE:
		default:
			sendCancel("Sorry, not possible.");
			break;
	}
}

void Player::sendStats()
{
	if(client)
		client->sendStats();
}

Item* Player::getWriteItem(uint32_t& _windowTextId, uint16_t& _maxWriteLen)
{
	_windowTextId = windowTextId;
	_maxWriteLen = maxWriteLen;
	return writeItem;
}

void Player::setWriteItem(Item* item, uint16_t _maxWriteLen/* = 0*/)
{
	windowTextId++;
	if(writeItem)
		writeItem->unRef();

	if(item)
	{
		writeItem = item;
		maxWriteLen = _maxWriteLen;
		writeItem->addRef();
	}
	else
	{
		writeItem = NULL;
		maxWriteLen = 0;
	}
}

House* Player::getEditHouse(uint32_t& _windowTextId, uint32_t& _listId)
{
	_windowTextId = windowTextId;
	_listId = editListId;
	return editHouse;
}

void Player::setEditHouse(House* house, uint32_t listId/* = 0*/)
{
	windowTextId++;
	editHouse = house;
	editListId = listId;
}

void Player::sendHouseWindow(House* house, uint32_t listId) const
{
	if(!client)
		return;

	std::string text;
	if(house->getAccessList(listId, text))
		client->sendHouseWindow(windowTextId, house, listId, text);
}

void Player::sendCreatureChangeVisible(const Creature* creature, Visible_t visible)
{
	if(!client)
		return;

	const Player* player = creature->getPlayer();
	if(player == this || (player && (visible < VISIBLE_GHOST_APPEAR || getGhostAccess() >= player->getGhostAccess()))
		|| (!player && canSeeInvisibility()))
		sendCreatureChangeOutfit(creature, creature->getCurrentOutfit());
	else if(visible == VISIBLE_DISAPPEAR || visible == VISIBLE_GHOST_DISAPPEAR)
		sendCreatureDisappear(creature, creature->getTile()->getClientIndexOfThing(this, creature));
	else
		sendCreatureAppear(creature);
}

void Player::sendAddContainerItem(const Container* container, const Item* item)
{
	if(!client)
		return;

	for(ContainerVector::const_iterator cl = containerVec.begin(); cl != containerVec.end(); ++cl)
	{
		if(cl->second == container)
			client->sendAddContainerItem(cl->first, item);
	}
}

void Player::sendUpdateContainerItem(const Container* container, uint8_t slot, const Item* oldItem, const Item* newItem)
{
	if(!client)
		return;

	for(ContainerVector::const_iterator cl = containerVec.begin(); cl != containerVec.end(); ++cl)
	{
		if(cl->second == container)
			client->sendUpdateContainerItem(cl->first, slot, newItem);
	}
}

void Player::sendRemoveContainerItem(const Container* container, uint8_t slot, const Item* item)
{
	if(!client)
		return;

	for(ContainerVector::const_iterator cl = containerVec.begin(); cl != containerVec.end(); ++cl)
	{
		if(cl->second == container)
			client->sendRemoveContainerItem(cl->first, slot);
	}
}

void Player::onUpdateTileItem(const Tile* tile, const Position& pos, const Item* oldItem,
	const ItemType& oldType, const Item* newItem, const ItemType& newType)
{
	Creature::onUpdateTileItem(tile, pos, oldItem, oldType, newItem, newType);
	if(oldItem != newItem)
		onRemoveTileItem(tile, pos, oldType, oldItem);

	if(tradeState != TRADE_TRANSFER && tradeItem && oldItem == tradeItem)
		g_game.internalCloseTrade(this);
}

void Player::onRemoveTileItem(const Tile* tile, const Position& pos, const ItemType& iType, const Item* item)
{
	Creature::onRemoveTileItem(tile, pos, iType, item);
	if(tradeState == TRADE_TRANSFER)
		return;

	checkTradeState(item);
	if(tradeItem)
	{
		const Container* container = item->getContainer();
		if(container && container->isHoldingItem(tradeItem))
			g_game.internalCloseTrade(this);
	}
}

void Player::onCreatureAppear(const Creature* creature)
{
	Creature::onCreatureAppear(creature);
	if(creature != this)
		return;

	Item* item = NULL;
	for(int32_t slot = SLOT_FIRST; slot <= SLOT_LAST; ++slot)
	{
		if (slot == 11 || slot == 12)
			continue;

		if(!(item = getInventoryItem((slots_t)slot)))
			continue;

		item->__startDecaying();
		g_moveEvents->onPlayerEquip(this, item, (slots_t)slot, false);
	}

	if(BedItem* bed = Beds::getInstance()->getBedBySleeper(guid))
		bed->wakeUp();

	Outfit outfit;
	if(Outfits::getInstance()->getOutfit(defaultOutfit.lookType, outfit))
		outfitAttributes = Outfits::getInstance()->addAttributes(getID(), outfit.outfitId, sex, defaultOutfit.lookAddons);

	if(lastLogout && stamina < STAMINA_MAX)
	{
		int64_t ticks = (int64_t)time(NULL) - lastLogout - 600;
		if(ticks > 0)
		{
			ticks = (int64_t)((double)(ticks * 1000) / g_config.getDouble(ConfigManager::RATE_STAMINA_GAIN));
			int64_t premium = g_config.getNumber(ConfigManager::STAMINA_LIMIT_TOP) * STAMINA_MULTIPLIER, period = ticks;
			if((int64_t)stamina <= premium)
			{
				period += stamina;
				if(period > premium)
					period -= premium;
				else
					period = 0;

				useStamina(ticks - period);
			}

			if(period > 0)
			{
				ticks = (int64_t)((g_config.getDouble(ConfigManager::RATE_STAMINA_GAIN) * period)
					/ g_config.getDouble(ConfigManager::RATE_STAMINA_THRESHOLD));
				if(stamina + ticks > STAMINA_MAX)
					ticks = STAMINA_MAX - stamina;

				useStamina(ticks);
			}

			sendStats();
		}
	}

	g_game.checkPlayersRecord(this);
	if(!isGhost())
		IOLoginData::getInstance()->updateOnlineStatus(guid, true);

	#if defined(WINDOWS) && !defined(__CONSOLE__)
	GUI::getInstance()->m_pBox.addPlayer(this);
	#endif
	if(g_config.getBool(ConfigManager::DISPLAY_LOGGING))
		std::cout << name << " has logged in." << std::endl;
}

void Player::onAttackedCreatureDisappear(bool isLogout)
{
	sendCancelTarget();
	if(!isLogout)
		sendTextMessage(MSG_STATUS_SMALL, "Target lost.");
}

void Player::onFollowCreatureDisappear(bool isLogout)
{
	sendCancelTarget();
	if(!isLogout)
		sendTextMessage(MSG_STATUS_SMALL, "Target lost.");
}

void Player::onChangeZone(ZoneType_t zone)
{
	if(attackedCreature && zone == ZONE_PROTECTION && !hasFlag(PlayerFlag_IgnoreProtectionZone))
	{
		setAttackedCreature(NULL);
		onAttackedCreatureDisappear(false);
	}
	sendIcons();
}

void Player::onAttackedCreatureChangeZone(ZoneType_t zone)
{
	if(zone == ZONE_PROTECTION && !hasFlag(PlayerFlag_IgnoreProtectionZone))
	{
		setAttackedCreature(NULL);
		onAttackedCreatureDisappear(false);
	}
	else if(zone == ZONE_NOPVP && attackedCreature->getPlayer() && !hasFlag(PlayerFlag_IgnoreProtectionZone))
	{
		setAttackedCreature(NULL);
		onAttackedCreatureDisappear(false);
	}
	else if(zone == ZONE_NORMAL && g_game.getWorldType() == WORLD_TYPE_NO_PVP && attackedCreature->getPlayer())
	{
		//attackedCreature can leave a pvp zone if not pzlocked
		setAttackedCreature(NULL);
		onAttackedCreatureDisappear(false);
	}
}

void Player::onCreatureDisappear(const Creature* creature, bool isLogout)
{
	if (!creature)
		return;
	
	Creature::onCreatureDisappear(creature, isLogout);
	if(creature != this)
		return;

	if(isLogout)
	{
		loginPosition = getPosition();
		lastLogout = time(NULL);
	}

	if(eventWalk)
		setFollowCreature(NULL);

	closeShopWindow();
	if(tradePartner)
		g_game.internalCloseTrade(this);

	clearPartyInvitations();
	if(party)
		party->leave(this);

	g_game.cancelRuleViolation(this);
	if(hasFlag(PlayerFlag_CanAnswerRuleViolations))
	{
		PlayerVector closeReportList;
		for(RuleViolationsMap::const_iterator it = g_game.getRuleViolations().begin(); it != g_game.getRuleViolations().end(); ++it)
		{
			if(it->second->gamemaster == this)
				closeReportList.push_back(it->second->reporter);
		}

		for(PlayerVector::iterator it = closeReportList.begin(); it != closeReportList.end(); ++it)
			g_game.closeRuleViolation(*it);
	}

	g_chat.removeUserFromAllChannels(this);
	if(!isGhost())
		IOLoginData::getInstance()->updateOnlineStatus(guid, false);

	#if defined(WINDOWS) && !defined(__CONSOLE__)
	GUI::getInstance()->m_pBox.removePlayer(this);
	#endif
	if(g_config.getBool(ConfigManager::DISPLAY_LOGGING))
		std::cout << getName() << " has logged out." << std::endl;

	bool saved = false;
	for(uint32_t tries = 0; !saved && tries < 3; ++tries)
	{
		if(IOLoginData::getInstance()->savePlayer(this))
			saved = true;
#ifdef __DEBUG__
		else
			std::cout << "Error while saving player: " << getName() << ", strike " << tries << "." << std::endl;
#endif
	}

	if(!saved)
#ifndef __DEBUG__
		std::cout << "Error while saving player: " << getName() << "." << std::endl;
#else
		std::cout << "Player " << getName() << " couldn't be saved." << std::endl;
#endif
}

void Player::openShopWindow()
{
	sendShop();
	sendGoods();
}

void Player::closeShopWindow(Npc* npc/* = NULL*/, int32_t onBuy/* = -1*/, int32_t onSell/* = -1*/)
{
	if(npc || (npc = getShopOwner(onBuy, onSell)))
		npc->onPlayerEndTrade(this, onBuy, onSell);

	if(shopOwner)
		sendCloseShop();

	shopOwner = NULL;
	purchaseCallback = saleCallback = -1;
	shopOffer.clear();
}

bool Player::canShopItem(uint16_t itemId, uint8_t subType, ShopEvent_t event)
{
	for(ShopInfoList::iterator sit = shopOffer.begin(); sit != shopOffer.end(); ++sit)
	{
		if(sit->itemId != itemId || ((event != SHOPEVENT_BUY || sit->buyPrice < 0)
			&& (event != SHOPEVENT_SELL || sit->sellPrice < 0)))
			continue;

		if(event == SHOPEVENT_SELL)
			return true;

		const ItemType& it = Item::items[id];
		if(it.isFluidContainer() || it.isSplash() || it.isRune())
			return sit->subType == subType;

		return true;
	}

	return false;
}

void Player::onWalk(Direction& dir)
{
	Creature::onWalk(dir);
	setNextActionTask(NULL);
	setNextAction(OTSYS_TIME() + getStepDuration(dir));
}

void Player::onCreatureMove(const Creature* creature, const Tile* newTile, const Position& newPos,
	const Tile* oldTile, const Position& oldPos, bool teleport)
{
	Creature::onCreatureMove(creature, newTile, newPos, oldTile, oldPos, teleport);
	if(creature != this)
		return;

	if(getParty())
		getParty()->updateSharedExperience();

	//check if we should close trade
	if(tradeState != TRADE_TRANSFER && ((tradeItem && !Position::areInRange<1,1,0>(tradeItem->getPosition(), getPosition()))
		|| (tradePartner && !Position::areInRange<2,2,0>(tradePartner->getPosition(), getPosition()))))
		g_game.internalCloseTrade(this);

	if((teleport || oldPos.z != newPos.z) && !hasCustomFlag(PlayerCustomFlag_CanStairhop))
	{
		int32_t ticks = g_config.getNumber(ConfigManager::STAIRHOP_DELAY);
		if(ticks > 0)
		{
			addExhaust(ticks, EXHAUST_COMBAT);
			if(Condition* condition = Condition::createCondition(CONDITIONID_DEFAULT, CONDITION_PACIFIED, ticks))
				addCondition(condition);
		}
	}
}

void Player::onAddContainerItem(const Container* container, const Item* item)
{
	checkTradeState(item);
}

void Player::onUpdateContainerItem(const Container* container, uint8_t slot,
	const Item* oldItem, const ItemType& oldType, const Item* newItem, const ItemType& newType)
{
	if(oldItem != newItem)
		onRemoveContainerItem(container, slot, oldItem);

	if(tradeState != TRADE_TRANSFER)
		checkTradeState(oldItem);
}

void Player::onRemoveContainerItem(const Container* container, uint8_t slot, const Item* item)
{
	if(tradeState == TRADE_TRANSFER)
		return;

	checkTradeState(item);
	if(tradeItem)
	{
		if(tradeItem->getParent() != container && container->isHoldingItem(tradeItem))
			g_game.internalCloseTrade(this);
	}
}

void Player::onCloseContainer(const Container* container)
{
	if(!client)
		return;

	for(ContainerVector::const_iterator cl = containerVec.begin(); cl != containerVec.end(); ++cl)
	{
		if(cl->second == container)
			client->sendCloseContainer(cl->first);
	}
}

void Player::onSendContainer(const Container* container)
{
	if(!client)
		return;

	bool hasParent = dynamic_cast<const Container*>(container->getParent()) != NULL;
	for(ContainerVector::const_iterator cl = containerVec.begin(); cl != containerVec.end(); ++cl)
	{
		if(cl->second == container)
			client->sendContainer(cl->first, container, hasParent);
	}
}

void Player::onUpdateInventoryItem(slots_t slot, Item* oldItem, const ItemType& oldType,
	Item* newItem, const ItemType& newType)
{
	if(oldItem != newItem)
		onRemoveInventoryItem(slot, oldItem);

	if(tradeState != TRADE_TRANSFER)
		checkTradeState(oldItem);
}

void Player::onRemoveInventoryItem(slots_t slot, Item* item)
{
	if(tradeState == TRADE_TRANSFER)
		return;

	checkTradeState(item);
	if(tradeItem)
	{
		const Container* container = item->getContainer();
		if(container && container->isHoldingItem(tradeItem))
			g_game.internalCloseTrade(this);
	}
}

void Player::checkTradeState(const Item* item)
{
	if(!tradeItem || tradeState == TRADE_TRANSFER)
		return;

	if(tradeItem != item)
	{
		const Container* container = dynamic_cast<const Container*>(item->getParent());
		while(container != NULL)
		{
			if(container == tradeItem)
			{
				g_game.internalCloseTrade(this);
				break;
			}

			container = dynamic_cast<const Container*>(container->getParent());
		}
	}
	else
		g_game.internalCloseTrade(this);
}

void Player::setNextWalkActionTask(SchedulerTask* task)
{
	if(walkTaskEvent)
	{
		Scheduler::getInstance().stopEvent(walkTaskEvent);
		walkTaskEvent = 0;
	}

	delete walkTask;
	walkTask = task;
	setIdleTime(0);
}

void Player::setNextWalkTask(SchedulerTask* task)
{
	if(nextStepEvent)
	{
		Scheduler::getInstance().stopEvent(nextStepEvent);
		nextStepEvent = 0;
	}

	if(task)
	{
		nextStepEvent = Scheduler::getInstance().addEvent(task);
		setIdleTime(0);
	}
}

void Player::setNextActionTask(SchedulerTask* task)
{
	if(actionTaskEvent)
	{
		Scheduler::getInstance().stopEvent(actionTaskEvent);
		actionTaskEvent = 0;
	}

	if(task)
	{
		actionTaskEvent = Scheduler::getInstance().addEvent(task);
		setIdleTime(0);
	}
}

uint32_t Player::getNextActionTime() const
{
	int64_t time = nextAction - OTSYS_TIME();
	if(time < SCHEDULER_MINTICKS)
		return SCHEDULER_MINTICKS;

	return time;
}

void Player::onThink(uint32_t interval)
{
	Creature::onThink(interval);
	int64_t timeNow = OTSYS_TIME();
	if(timeNow - lastPing >= 5000)
	{
		lastPing = timeNow;
		if(client)
			client->sendPing();
		else if(g_config.getBool(ConfigManager::STOP_ATTACK_AT_EXIT))
			setAttackedCreature(NULL);
	}

	if((timeNow - lastPong) >= 60000 && canLogout(true))
	{
		if(client)
			client->logout(true, true);
		else if(g_creatureEvents->playerLogout(this, true))
			g_game.removeCreature(this, true);
	}

	messageTicks += interval;
	if(messageTicks >= 1500)
	{
		messageTicks = 0;
		addMessageBuffer();
	}
}

bool Player::isMuted(uint16_t channelId, SpeakClasses type, uint32_t& time)
{
	time = 0;
	if(hasFlag(PlayerFlag_CannotBeMuted))
		return false;

	int32_t muteTicks = 0;
	for(ConditionList::iterator it = conditions.begin(); it != conditions.end(); ++it)
	{
		if((*it)->getType() == CONDITION_MUTED && (*it)->getSubId() == 0 && (*it)->getTicks() > muteTicks)
			muteTicks = (*it)->getTicks();
	}

	time = (uint32_t)muteTicks / 1000;
	return time > 0 && type != SPEAK_PRIVATE_PN && (type != SPEAK_CHANNEL_Y || (channelId != CHANNEL_GUILD && !g_chat.isPrivateChannel(channelId)));
}

void Player::addMessageBuffer()
{
	if(!hasFlag(PlayerFlag_CannotBeMuted) && g_config.getNumber(
		ConfigManager::MAX_MESSAGEBUFFER) != 0 && messageBuffer > 0)
		messageBuffer--;
}

void Player::removeMessageBuffer()
{
	int32_t maxBuffer = g_config.getNumber(ConfigManager::MAX_MESSAGEBUFFER);
	if(!hasFlag(PlayerFlag_CannotBeMuted) && maxBuffer != 0 && messageBuffer <= maxBuffer + 1)
	{
		if(++messageBuffer > maxBuffer)
		{
			uint32_t muteCount = 1;
			MuteCountMap::iterator it = muteCountMap.find(guid);
			if(it != muteCountMap.end())
				muteCount = it->second;

			uint32_t muteTime = 1000; // Thalles
			muteCountMap[guid] = muteCount + 1;
			if(Condition* condition = Condition::createCondition(CONDITIONID_DEFAULT, CONDITION_MUTED, muteTime * 1000))
				addCondition(condition);

			char buffer[50];
			sprintf(buffer, "You are muted for %d seconds.", muteTime);
			sendTextMessage(MSG_STATUS_SMALL, buffer);
		}
	}
}

void Player::drainHealth(Creature* attacker, CombatType_t combatType, int32_t damage)
{
	Creature::drainHealth(attacker, combatType, damage);
	char buffer[150];
	if(attacker)
		sprintf(buffer, "You lose %d hitpoint%s due to an attack by %s.", damage, (damage != 1 ? "s" : ""), attacker->getNameDescription().c_str());
	else
		sprintf(buffer, "You lose %d hitpoint%s.", damage, (damage != 1 ? "s" : ""));

	sendStats();
	sendTextMessage(MSG_EVENT_DEFAULT, buffer);
}

void Player::drainMana(Creature* attacker, CombatType_t combatType, int32_t damage)
{
	Creature::drainMana(attacker, combatType, damage);
	char buffer[150];
	if(attacker)
		sprintf(buffer, "You lose %d mana blocking an attack by %s.", damage, attacker->getNameDescription().c_str());
	else
		sprintf(buffer, "You lose %d mana.", damage);

	sendStats();
}

void Player::addManaSpent(uint64_t amount, bool useMultiplier/* = true*/)
{
	if(!amount)
		return;

	uint64_t currReqMana = vocation->getReqMana(magLevel), nextReqMana = vocation->getReqMana(magLevel + 1);
	if(currReqMana > nextReqMana) //player has reached max magic level
		return;

	if(useMultiplier)
		amount = uint64_t((double)amount * rates[SKILL__MAGLEVEL] * g_config.getDouble(ConfigManager::RATE_MAGIC));

	bool advance = false;
	while(manaSpent + amount >= nextReqMana)
	{
		amount -= nextReqMana - manaSpent;
		manaSpent = 0;
		magLevel++;

		char advMsg[50];
		sprintf(advMsg, "You advanced to magic level %d.", magLevel);
		sendTextMessage(MSG_EVENT_ADVANCE, advMsg);

		advance = true;
		CreatureEventList advanceEvents = getCreatureEvents(CREATURE_EVENT_ADVANCE);
		for(CreatureEventList::iterator it = advanceEvents.begin(); it != advanceEvents.end(); ++it)
			(*it)->executeAdvance(this, SKILL__MAGLEVEL, (magLevel - 1), magLevel);

		currReqMana = nextReqMana;
		nextReqMana = vocation->getReqMana(magLevel + 1);
		if(currReqMana > nextReqMana)
		{
			amount = 0;
			break;
		}
	}

	if(amount)
		manaSpent += amount;

	uint32_t newPercent = Player::getPercentLevel(manaSpent, nextReqMana);
	if(magLevelPercent != newPercent)
	{
		magLevelPercent = newPercent;
		sendStats();
	}
	else if(advance)
		sendStats();
}

void Player::addExperience(uint64_t exp)
{
	uint32_t prevLevel = level;
	uint64_t nextLevelExp = Player::getExpForLevel(level + 1);
	if(Player::getExpForLevel(level) > nextLevelExp)
	{
		//player has reached max level
		levelPercent = 0;
		sendStats();
		return;
	}

	experience += exp;
	while(experience >= nextLevelExp)
	{
		healthMax += vocation->getGain(GAIN_HEALTH);
		health += vocation->getGain(GAIN_HEALTH);
		manaMax += vocation->getGain(GAIN_MANA);
		mana += vocation->getGain(GAIN_MANA);
		capacity += vocation->getGainCap();

		++level;
		nextLevelExp = Player::getExpForLevel(level + 1);
		if(Player::getExpForLevel(level) > nextLevelExp) //player has reached max level
			break;
	}

	if(prevLevel != level)
	{
		updateBaseSpeed();
		setBaseSpeed(getBaseSpeed());

		g_game.changeSpeed(this, 0);
		g_game.addCreatureHealth(this);
		if(getParty())
			getParty()->updateSharedExperience();

		char advMsg[60];
		sprintf(advMsg, "Voce avancou do Level %d para o Level %d.", prevLevel, level);
		sendTextMessage(MSG_EVENT_ADVANCE, advMsg);

		CreatureEventList advanceEvents = getCreatureEvents(CREATURE_EVENT_ADVANCE);
		for(CreatureEventList::iterator it = advanceEvents.begin(); it != advanceEvents.end(); ++it)
			(*it)->executeAdvance(this, SKILL__LEVEL, prevLevel, level);
	}

	uint64_t currLevelExp = Player::getExpForLevel(level);
	nextLevelExp = Player::getExpForLevel(level + 1);
	levelPercent = 0;
	if(nextLevelExp > currLevelExp)
		levelPercent = Player::getPercentLevel(experience - currLevelExp, nextLevelExp - currLevelExp);

	sendStats();
}

void Player::removeExperience(uint64_t exp, bool updateStats/* = true*/)
{
	uint32_t prevLevel = level;
	experience -= std::min(exp, experience);
	while(level > 1 && experience < Player::getExpForLevel(level))
	{
		level--;
		healthMax = std::max((int32_t)0, (healthMax - (int32_t)vocation->getGain(GAIN_HEALTH)));
		manaMax = std::max((int32_t)0, (manaMax - (int32_t)vocation->getGain(GAIN_MANA)));
		capacity = std::max((double)0, (capacity - (double)vocation->getGainCap()));
	}

	if(prevLevel != level)
	{
		if(updateStats)
		{
			updateBaseSpeed();
			setBaseSpeed(getBaseSpeed());

			g_game.changeSpeed(this, 0);
			g_game.addCreatureHealth(this);
		}

		char advMsg[90];
		sprintf(advMsg, "You were downgraded from Level %d to Level %d.", prevLevel, level);
		sendTextMessage(MSG_EVENT_ADVANCE, advMsg);
	}

	uint64_t currLevelExp = Player::getExpForLevel(level);
	uint64_t nextLevelExp = Player::getExpForLevel(level + 1);
	if(nextLevelExp > currLevelExp)
		levelPercent = Player::getPercentLevel(experience - currLevelExp, nextLevelExp - currLevelExp);
	else
		levelPercent = 0;

	if(updateStats)
		sendStats();
}

uint32_t Player::getPercentLevel(uint64_t count, uint64_t nextLevelCount)
{
	if(nextLevelCount > 0)
		return std::min((uint32_t)100, std::max((uint32_t)0, uint32_t(count * 100 / nextLevelCount)));

	return 0;
}

void Player::onBlockHit(BlockType_t blockType)
{
	if(shieldBlockCount > 0)
	{
		--shieldBlockCount;
		if(hasShield())
			addSkillAdvance(SKILL_SHIELD, 1);
	}
}

void Player::onAttackedCreatureBlockHit(Creature* target, BlockType_t blockType)
{
	Creature::onAttackedCreatureBlockHit(target, blockType);
	lastAttackBlockType = blockType;
	switch(blockType)
	{
		case BLOCK_NONE:
		{
			addAttackSkillPoint = true;
			bloodHitCount = 30;
			shieldBlockCount = 30;
			break;
		}

		case BLOCK_DEFENSE:
		case BLOCK_ARMOR:
		{
			//need to draw blood every 30 hits
			if(bloodHitCount > 0)
			{
				addAttackSkillPoint = true;
				--bloodHitCount;
			}
			else
				addAttackSkillPoint = false;

			break;
		}

		default:
		{
			addAttackSkillPoint = false;
			break;
		}
	}
}

bool Player::hasShield() const
{
	bool result = false;
	Item* item = getInventoryItem(SLOT_LEFT);
	if(item && item->getWeaponType() == WEAPON_SHIELD)
		result = true;

	item = getInventoryItem(SLOT_RIGHT);
	if(item && item->getWeaponType() == WEAPON_SHIELD)
		result = true;

	return result;
}

BlockType_t Player::blockHit(Creature* attacker, CombatType_t combatType, int32_t& damage,
	bool checkDefense/* = false*/, bool checkArmor/* = false*/)
{
	BlockType_t blockType = Creature::blockHit(attacker, combatType, damage, checkDefense, checkArmor);
	if(attacker)
	{
		int16_t color = g_config.getNumber(ConfigManager::SQUARE_COLOR);
		if(color < 0)
			color = random_range(0, 255);

		sendCreatureSquare(attacker, (SquareColor_t)color);
	}

	if(blockType != BLOCK_NONE)
		return blockType;

	if(vocation->getMultiplier(MULTIPLIER_MAGICDEFENSE) != 1.0 && combatType != COMBAT_NONE &&
		combatType != COMBAT_PHYSICALDAMAGE && combatType == COMBAT_UNDEFINEDDAMAGE &&
		combatType != COMBAT_DROWNDAMAGE)
		damage -= (int32_t)std::ceil((double)(damage * vocation->getMultiplier(MULTIPLIER_MAGICDEFENSE)) / 100.);

	return blockType;
}

uint32_t Player::getIP() const
{
	if(client)
		return client->getIP();

	return lastIP;
}

bool Player::onDeath()
{
	Item* preventLoss = NULL;
	Item* preventDrop = NULL;
	if(getZone() == ZONE_PVP)
	{
		setDropLoot(LOOT_DROP_NONE);
		setLossSkill(false);
	}
	else if(skull < SKULL_RED && g_game.getWorldType() != WORLD_TYPE_PVP_ENFORCED)
	{
		Item* item = NULL;
		for(int32_t i = SLOT_FIRST; ((skillLoss || lootDrop == LOOT_DROP_FULL) && i <= SLOT_LAST); ++i)
		{
			if (i == 11 || i == 12)
				continue;

			if(!(item = getInventoryItem((slots_t)i)) || (g_moveEvents->hasEquipEvent(item)))
				continue;

			const ItemType& it = Item::items[item->getID()];
			if(lootDrop == LOOT_DROP_FULL && it.abilities.preventDrop)
			{
				setDropLoot(LOOT_DROP_PREVENT);
				preventDrop = item;
			}

			if(skillLoss && !preventLoss && it.abilities.preventLoss)
				preventLoss = item;
		}
	}

	if(!Creature::onDeath())
	{
		if(preventDrop)
			setDropLoot(LOOT_DROP_FULL);

		return false;
	}

	if(preventLoss)
	{
		setLossSkill(false);
		if(preventLoss->getCharges() > 1) //weird, but transform failed to remove for some hosters
			g_game.transformItem(preventLoss, preventLoss->getID(), std::max(0, ((int32_t)preventLoss->getCharges() - 1)));
		else
			g_game.internalRemoveItem(NULL, preventDrop);
	}

	if(preventDrop && preventDrop != preventLoss)
	{
		if(preventDrop->getCharges() > 1) //weird, but transform failed to remove for some hosters
			g_game.transformItem(preventDrop, preventDrop->getID(), std::max(0, ((int32_t)preventDrop->getCharges() - 1)));
		else
			g_game.internalRemoveItem(NULL, preventDrop);
	}

	removeConditions(CONDITIONEND_DEATH);
	if(skillLoss)
	{
		uint64_t lossExperience = getLostExperience();
		removeExperience(lossExperience, false);
		double percent = 1. - ((double)(experience - lossExperience) / experience);

		//Magic level loss
		uint32_t sumMana = 0;
		uint64_t lostMana = 0;
		for(uint32_t i = 1; i <= magLevel; ++i)
			sumMana += vocation->getReqMana(i);

		sumMana += manaSpent;
		lostMana = (uint64_t)std::ceil(sumMana * ((double)(percent * lossPercent[LOSS_MANA]) / 100.));
		while(lostMana > manaSpent && magLevel > 0)
		{
			lostMana -= manaSpent;
			manaSpent = vocation->getReqMana(magLevel);
			magLevel--;
		}

		manaSpent -= std::max((int32_t)0, (int32_t)lostMana);
		uint64_t nextReqMana = vocation->getReqMana(magLevel + 1);
		if(nextReqMana > vocation->getReqMana(magLevel))
			magLevelPercent = Player::getPercentLevel(manaSpent, nextReqMana);
		else
			magLevelPercent = 0;

		//Skill loss
		uint32_t lostSkillTries, sumSkillTries;
		for(int16_t i = 0; i < 7; ++i) //for each skill
		{
			lostSkillTries = sumSkillTries = 0;
			for(uint32_t c = 11; c <= skills[i][SKILL_LEVEL]; ++c) //sum up all required tries for all skill levels
				sumSkillTries += vocation->getReqSkillTries(i, c);

			sumSkillTries += skills[i][SKILL_TRIES];
			lostSkillTries = (uint32_t)std::ceil(sumSkillTries * ((double)(percent * lossPercent[LOSS_SKILLS]) / 100.));
			while(lostSkillTries > skills[i][SKILL_TRIES])
			{
				lostSkillTries -= skills[i][SKILL_TRIES];
				skills[i][SKILL_TRIES] = vocation->getReqSkillTries(i, skills[i][SKILL_LEVEL]);
				if(skills[i][SKILL_LEVEL] < 11)
				{
					skills[i][SKILL_LEVEL] = 10;
					skills[i][SKILL_TRIES] = lostSkillTries = 0;
					break;
				}
				else
					skills[i][SKILL_LEVEL]--;
			}

			skills[i][SKILL_TRIES] = std::max((int32_t)0, (int32_t)(skills[i][SKILL_TRIES] - lostSkillTries));
		}

		blessings = 0;
		loginPosition = masterPosition;
		if(!inventory[SLOT_BACKPACK])
			__internalAddThing(SLOT_BACKPACK, Item::CreateItem(g_config.getNumber(ConfigManager::DEATH_CONTAINER)));

		sendIcons();
		sendStats();
		sendSkills();

		sendReLoginWindow();
		g_game.removeCreature(this, false);
	}
	else
	{
		setLossSkill(true);
		if(preventLoss)
		{
			loginPosition = masterPosition;
			sendReLoginWindow();
			g_game.removeCreature(this, false);
		}
	}

	return true;
}

void Player::dropCorpse(DeathList deathList)
{
	if(lootDrop == LOOT_DROP_NONE)
	{
		pzLocked = false;
		if(health <= 0)
		{
			health = healthMax;
			mana = manaMax;
		}

		setDropLoot(LOOT_DROP_FULL);
		sendStats();
		sendIcons();

		onIdleStatus();
		g_game.addCreatureHealth(this);
		g_game.internalTeleport(this, masterPosition, true);
	}
	else
	{
		Creature::dropCorpse(deathList);
		if(g_config.getBool(ConfigManager::DEATH_LIST))
			IOLoginData::getInstance()->playerDeath(this, deathList);
	}
}

Item* Player::createCorpse(DeathList deathList)
{
	Item* corpse = Creature::createCorpse(deathList);
	if(!corpse)
		return NULL;

	std::stringstream ss;
	ss << "You recognize " << getNameDescription() << ". " << (sex % 2 ? "He" : "She") << " was killed by ";
	if(deathList[0].isCreatureKill())
	{
		ss << deathList[0].getKillerCreature()->getNameDescription();
		if(deathList[0].getKillerCreature()->getMaster())
			ss << " summoned by " << deathList[0].getKillerCreature()->getMaster()->getNameDescription();
	}
	else
		ss << deathList[0].getKillerName();

	if(deathList.size() > 1)
	{
		if(deathList[0].getKillerType() != deathList[1].getKillerType())
		{
			if(deathList[1].isCreatureKill())
			{
				ss << " and by " << deathList[1].getKillerCreature()->getNameDescription();
				if(deathList[1].getKillerCreature()->getMaster())
					ss << " summoned by " << deathList[1].getKillerCreature()->getMaster()->getNameDescription();
			}
			else
				ss << " and by " << deathList[1].getKillerName();
		}
		else if(deathList[1].isCreatureKill())
		{
			if(deathList[0].getKillerCreature()->getName() != deathList[1].getKillerCreature()->getName())
			{
				ss << " and by " << deathList[1].getKillerCreature()->getNameDescription();
				if(deathList[1].getKillerCreature()->getMaster())
					ss << " summoned by " << deathList[1].getKillerCreature()->getMaster()->getNameDescription();
			}
		}
		else if(asLowerCaseString(deathList[0].getKillerName()) != asLowerCaseString(deathList[1].getKillerName()))
			ss << " and by " << deathList[1].getKillerName();
	}

	ss << ".";
	corpse->setSpecialDescription(ss.str().c_str());
	return corpse;
}

void Player::addExhaust(uint32_t ticks, Exhaust_t type)
{
	if(Condition* condition = Condition::createCondition(CONDITIONID_DEFAULT, CONDITION_EXHAUST, ticks, 0, false, type))
		addCondition(condition);
}

void Player::addInFightTicks(bool pzLock/* = false*/)
{
	if(hasFlag(PlayerFlag_NotGainInFight))
		return;

	if(pzLock)
		pzLocked = true;

	if(Condition* condition = Condition::createCondition(CONDITIONID_DEFAULT,
		CONDITION_INFIGHT, g_config.getNumber(ConfigManager::PZ_LOCKED)))
		addCondition(condition);
}

void Player::addDefaultRegeneration(uint32_t addTicks)
{
	Condition* condition = getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT);
	if(condition)
		condition->setTicks(condition->getTicks() + addTicks);
	else if((condition = Condition::createCondition(CONDITIONID_DEFAULT, CONDITION_REGENERATION, addTicks)))
	{
		condition->setParam(CONDITIONPARAM_HEALTHGAIN, vocation->getGainAmount(GAIN_HEALTH));
		condition->setParam(CONDITIONPARAM_HEALTHTICKS, vocation->getGainTicks(GAIN_HEALTH) * 1000);
		condition->setParam(CONDITIONPARAM_MANAGAIN, vocation->getGainAmount(GAIN_MANA));
		condition->setParam(CONDITIONPARAM_MANATICKS, vocation->getGainTicks(GAIN_MANA) * 1000);
		addCondition(condition);
	}
}

void Player::removeList()
{
	autoList.erase(id);
	if(!isGhost())
	{
		for(AutoList<Player>::iterator it = autoList.begin(); it != autoList.end(); ++it)
			it->second->notifyLogOut(this);
	}
	else
	{
		for(AutoList<Player>::iterator it = autoList.begin(); it != autoList.end(); ++it)
		{
			if(it->second->canSeeCreature(this))
				it->second->notifyLogOut(this);
		}
	}
}

void Player::addList()
{
	if(!isGhost())
	{
		for(AutoList<Player>::iterator it = autoList.begin(); it != autoList.end(); ++it)
			it->second->notifyLogIn(this);
	}
	else
	{
		for(AutoList<Player>::iterator it = autoList.begin(); it != autoList.end(); ++it)
		{
			if(it->second->canSeeCreature(this))
				it->second->notifyLogIn(this);
		}
	}

	autoList[id] = this;
}

void Player::kickPlayer(bool displayEffect, bool forceLogout)
{
	if(!client)
	{
		if(g_creatureEvents->playerLogout(this, forceLogout))
			g_game.removeCreature(this);
	}
	else
		client->logout(displayEffect, forceLogout);
}

void Player::notifyLogIn(Player* loginPlayer)
{
	if(!client)
		return;

	VIPListSet::iterator it = VIPList.find(loginPlayer->getGUID());
	if(it != VIPList.end())
		client->sendVIPLogIn(loginPlayer->getGUID());
}

void Player::notifyLogOut(Player* logoutPlayer)
{
	if(!client)
		return;

	VIPListSet::iterator it = VIPList.find(logoutPlayer->getGUID());
	if(it != VIPList.end())
		client->sendVIPLogOut(logoutPlayer->getGUID());
}

bool Player::removeVIP(uint32_t _guid)
{
	VIPListSet::iterator it = VIPList.find(_guid);
	if(it == VIPList.end())
		return false;

	VIPList.erase(it);
	return true;
}

bool Player::addVIP(uint32_t _guid, std::string& name, bool isOnline, bool internal/* = false*/)
{
	if(guid == _guid)
	{
		if(!internal)
			sendTextMessage(MSG_STATUS_SMALL, "You cannot add yourself.");

		return false;
	}

	if(VIPList.size() > (group ? group->getMaxVips(isPremium()) : 20))
	{
		if(!internal)
			sendTextMessage(MSG_STATUS_SMALL, "You cannot add more buddies.");

		return false;
	}

	VIPListSet::iterator it = VIPList.find(_guid);
	if(it != VIPList.end())
	{
		if(!internal)
			sendTextMessage(MSG_STATUS_SMALL, "This player is already in your list.");

		return false;
	}

	VIPList.insert(_guid);
	if(client && !internal)
		client->sendVIP(_guid, name, isOnline);

	return true;
}

//close container and its child containers
void Player::autoCloseContainers(const Container* container)
{
	if (!container)
		return;

	/* if (container->isRemoved())
		return; */

	typedef std::vector<uint32_t> CloseList;
	CloseList closeList;

	if (!containerVec.empty() && containerVec.size() > 0) {
		for(ContainerVector::iterator it = containerVec.begin(); it != containerVec.end(); ++it)
		{
			Container* tmp = it->second;
			/* if (!tmp)
				continue; */

			while(tmp != NULL)
			{
				if (!tmp)
					continue;

				if ((tmp && tmp->isRemoved()) || (tmp && tmp == container))
				{
					closeList.push_back(it->first);
					break;
				}

				if (tmp && tmp->getParent()) {
					tmp = dynamic_cast<Container*>(tmp->getParent());
				}
			}
		}
	}

	if (closeList.size() > 0) {
		for(CloseList::iterator it = closeList.begin(); it != closeList.end(); ++it)
		{
			closeContainer(*it);
			if(client)
				client->sendCloseContainer(*it);
		}
	}
}

bool Player::hasCapacity(const Item* item, uint32_t count, uint32_t index) const
{
	if (hasFlag(PlayerFlag_CannotPickupItem))
		return false;

	if (hasFlag(PlayerFlag_HasInfiniteCapacity) || item->getTopParent() == this)
		return true;

	if (excededPokemonsLimit(pokemonCountIn(item)))
		return false;
	return true;
}


ReturnValue Player::__queryAdd(int32_t index, const Thing* thing, uint32_t count, uint32_t flags) const
{
	const Item* item = thing->getItem();
	if(!item)
		return RET_NOTPOSSIBLE;

	if(!item->isPickupable())
		return RET_CANNOTPICKUP;

	bool childIsOwner = ((flags & FLAG_CHILDISOWNER) == FLAG_CHILDISOWNER), skipLimit = ((flags & FLAG_NOLIMIT) == FLAG_NOLIMIT);
	if(childIsOwner)
	{
		//a child container is querying the player, just check if enough capacity
		if(skipLimit || hasCapacity(item, count, index))
			return RET_NOERROR;

		return RET_NOTENOUGHCAPACITY;
	}

	ReturnValue ret = RET_NOERROR;
	if((item->getSlotPosition() & SLOTP_HEAD) || (item->getSlotPosition() & SLOTP_NECKLACE) ||
		(item->getSlotPosition() & SLOTP_BACKPACK) || (item->getSlotPosition() & SLOTP_ARMOR) ||
		(item->getSlotPosition() & SLOTP_LEGS) || (item->getSlotPosition() & SLOTP_FEET) ||
		(item->getSlotPosition() & SLOTP_RING) || (item->getSlotPosition() & SLOTP_CATCHBAG))
		ret = RET_CANNOTBEDRESSED;
	else if(item->getSlotPosition() & SLOTP_TWO_HAND)
		ret = RET_PUTTHISOBJECTINBOTHHANDS;
	else if((item->getSlotPosition() & SLOTP_RIGHT) || (item->getSlotPosition() & SLOTP_LEFT))
		ret = RET_PUTTHISOBJECTINYOURHAND;

	switch(index)
	{
		case SLOT_HEAD:
			if(item->getSlotPosition() & SLOTP_HEAD)
				ret = RET_NOERROR;
			break;
		case SLOT_NECKLACE:
			if(item->getSlotPosition() & SLOTP_NECKLACE)
				ret = RET_NOERROR;
			break;
		case SLOT_BACKPACK:
			if(item->getSlotPosition() & SLOTP_BACKPACK)
				ret = RET_NOERROR;
			break;
		case SLOT_ARMOR:
			if(item->getSlotPosition() & SLOTP_ARMOR)
				ret = RET_NOERROR;
			break;
		case SLOT_RIGHT:
			if(item->getSlotPosition() & SLOTP_RIGHT)
			{
				//check if we already carry an item in the other hand
				if(item->getSlotPosition() & SLOTP_TWO_HAND)
				{
					if(inventory[SLOT_LEFT] && inventory[SLOT_LEFT] != item)
						ret = RET_BOTHHANDSNEEDTOBEFREE;
					else
						ret = RET_NOERROR;
				}
				else if(inventory[SLOT_LEFT])
				{
					const Item* leftItem = inventory[SLOT_LEFT];
					WeaponType_t type = item->getWeaponType(), leftType = leftItem->getWeaponType();
					if(leftItem->getSlotPosition() & SLOTP_TWO_HAND)
						ret = RET_DROPTWOHANDEDITEM;
					else if(item == leftItem && count == item->getItemCount())
						ret = RET_NOERROR;
					else if(leftType == WEAPON_SHIELD && type == WEAPON_SHIELD)
						ret = RET_CANONLYUSEONESHIELD;
					else if(!leftItem->isWeapon() || !item->isWeapon() ||
						leftType == WEAPON_SHIELD || leftType == WEAPON_AMMO
						|| type == WEAPON_SHIELD || type == WEAPON_AMMO)
						ret = RET_NOERROR;
					else
						ret = RET_CANONLYUSEONEWEAPON;
				}
				else
					ret = RET_NOERROR;
			}
			break;
		case SLOT_LEFT:
			if(item->getSlotPosition() & SLOTP_LEFT)
			{
				//check if we already carry an item in the other hand
				if(item->getSlotPosition() & SLOTP_TWO_HAND)
				{
					if(inventory[SLOT_RIGHT] && inventory[SLOT_RIGHT] != item)
						ret = RET_BOTHHANDSNEEDTOBEFREE;
					else
						ret = RET_NOERROR;
				}
				else if(inventory[SLOT_RIGHT])
				{
					const Item* rightItem = inventory[SLOT_RIGHT];
					WeaponType_t type = item->getWeaponType(), rightType = rightItem->getWeaponType();
					if(rightItem->getSlotPosition() & SLOTP_TWO_HAND)
						ret = RET_DROPTWOHANDEDITEM;
					else if(item == rightItem && count == item->getItemCount())
						ret = RET_NOERROR;
					else if(rightType == WEAPON_SHIELD && type == WEAPON_SHIELD)
						ret = RET_CANONLYUSEONESHIELD;
					else if(!rightItem->isWeapon() || !item->isWeapon() ||
						rightType == WEAPON_SHIELD || rightType == WEAPON_AMMO
						|| type == WEAPON_SHIELD || type == WEAPON_AMMO)
						ret = RET_NOERROR;
					else
						ret = RET_CANONLYUSEONEWEAPON;
				}
				else
					ret = RET_NOERROR;
			}
			break;
		case SLOT_LEGS:
			if(item->getSlotPosition() & SLOTP_LEGS)
				ret = RET_NOERROR;
			break;
		case SLOT_FEET:
			if(item->getSlotPosition() & SLOTP_FEET)
				ret = RET_NOERROR;
			break;
		case SLOT_RING:
			if(item->getSlotPosition() & SLOTP_RING)
				ret = RET_NOERROR;
			break;
		case SLOT_AMMO:
			if(item->getSlotPosition() & SLOTP_AMMO)
				ret = RET_NOERROR;
			break;
		case SLOT_CATCHBAG:
			if(item->getSlotPosition() & SLOTP_CATCHBAG)
				ret = RET_NOERROR;
			break;
		case SLOT_WHEREEVER:
		case -1:
			ret = RET_NOTENOUGHROOM;
			break;
		default:
			ret = RET_NOTPOSSIBLE;
			break;
	}

	if(ret == RET_NOERROR || ret == RET_NOTENOUGHROOM)
	{
		//need an exchange with source?
		if(getInventoryItem((slots_t)index) != NULL && (!getInventoryItem((slots_t)index)->isStackable()
			|| getInventoryItem((slots_t)index)->getID() != item->getID()))
			return RET_NEEDEXCHANGE;

		if(!g_moveEvents->onPlayerEquip(const_cast<Player*>(this), const_cast<Item*>(item), (slots_t)index, true))
			return RET_CANNOTBEDRESSED;

		//check if enough capacity
		if(!hasCapacity(item, count, index)) {
			return RET_NOTENOUGHCAPACITY;
		}
	}

	return ret;
}

ReturnValue Player::__queryMaxCount(int32_t index, const Thing* thing, uint32_t count, uint32_t& maxQueryCount,
	uint32_t flags) const
{
	const Item* item = thing->getItem();
	if(!item)
	{
		maxQueryCount = 0;
		return RET_NOTPOSSIBLE;
	}

	const Thing* destThing = __getThing(index);
	const Item* destItem = NULL;
	if(destThing)
		destItem = destThing->getItem();

	if(destItem)
	{
		if(destItem->isStackable() && item->getID() == destItem->getID())
			maxQueryCount = 100 - destItem->getItemCount();
		else
			maxQueryCount = 0;
	}
	else
	{
		if(item->isStackable())
			maxQueryCount = 100;
		else
			maxQueryCount = 1;

		return RET_NOERROR;
	}

	if(maxQueryCount < count)
		return RET_NOTENOUGHROOM;

	return RET_NOERROR;
}

ReturnValue Player::__queryRemove(const Thing* thing, uint32_t count, uint32_t flags) const
{
	int32_t index = __getIndexOfThing(thing);
	if(index == -1)
		return RET_NOTPOSSIBLE;

	const Item* item = thing->getItem();
	if(!item)
		return RET_NOTPOSSIBLE;

	if(count == 0 || (item->isStackable() && count > item->getItemCount()))
		return RET_NOTPOSSIBLE;

	 if(item->isNotMoveable() && !hasBitSet(FLAG_IGNORENOTMOVEABLE, flags))
		return RET_NOTMOVEABLE;

	return RET_NOERROR;
}

Cylinder* Player::__queryDestination(int32_t& index, const Thing* thing, Item** destItem,
	uint32_t& flags)
{
	if(index == 0 /*drop to capacity window*/ || index == INDEX_WHEREEVER)
	{
		*destItem = NULL;
		const Item* item = thing->getItem();
		if(!item)
			return this;

		//find a appropiate slot
		for(int32_t i = SLOT_FIRST; i <= SLOT_LAST; ++i)
		{
			if (i == 11 || i == 12)
				continue;

			if (i == 13 && item->getID() != 28146 && item->getPokemon().empty())
				continue;

			if (i == 1 && item->getID() != 28204 && item->getPokemon().empty())
				continue;
			
			if(!inventory[i] && __queryAdd(i, item, item->getItemCount(), 0) == RET_NOERROR)
			{
				index = i;
				return this;
			}
		}

		//try containers
		std::list<std::pair<Container*, int32_t> > deepList;
		for(int32_t i = SLOT_FIRST; i <= SLOT_LAST; ++i)
		{
			if (i == 11 || i == 12 || i == 14)
				continue;

			if(inventory[i] == tradeItem)
				continue;

			if (i == 13 && item->getID() != 28146 && item->getPokemon().empty())
				continue;

			if (i == 1 && item->getID() != 28204 && item->getPokemon().empty())
				continue;

			if(Container* container = dynamic_cast<Container*>(inventory[i]))
			{
				if(container->__queryAdd(-1, item, item->getItemCount(), 0) == RET_NOERROR)
				{
					index = INDEX_WHEREEVER;
					*destItem = NULL;
					return container;
				}

				deepList.push_back(std::make_pair(container, 0));
			}
		}

		//check deeper in the containers
		int32_t deepness = g_config.getNumber(ConfigManager::PLAYER_DEEPNESS);
		for(std::list<std::pair<Container*, int32_t> >::iterator dit = deepList.begin(); dit != deepList.end(); ++dit)
		{
			Container* c = (*dit).first;
			if(!c || c->empty())
				continue;

			int32_t level = (*dit).second;
			for(ItemList::const_iterator it = c->getItems(); it != c->getEnd(); ++it)
			{
				if((*it) == tradeItem)
					continue;

				if(Container* subContainer = dynamic_cast<Container*>(*it))
				{
					if(subContainer->__queryAdd(-1, item, item->getItemCount(), 0) == RET_NOERROR)
					{
						index = INDEX_WHEREEVER;
						*destItem = NULL;
						return subContainer;
					}

					if(deepness < 0 || level < deepness)
						deepList.push_back(std::make_pair(subContainer, (level + 1)));
				}
			}
		}

		return this;
	}

	Thing* destThing = __getThing(index);
	if(destThing)
		*destItem = destThing->getItem();

	if(Cylinder* subCylinder = dynamic_cast<Cylinder*>(destThing))
	{
		index = INDEX_WHEREEVER;
		*destItem = NULL;
		return subCylinder;
	}

	return this;
}

void Player::__addThing(Creature* actor, Thing* thing)
{
	__addThing(actor, 0, thing);
}

void Player::__addThing(Creature* actor, int32_t index, Thing* thing)
{
	if(index < 0 || index > 13)
	{
#ifdef __DEBUG_MOVESYS__
		std::cout << "Failure: [Player::__addThing], " << "player: " << getName() << ", index: " << index << ", index < 0 || index > 13" << std::endl;
		DEBUG_REPORT
#endif
		return /*RET_NOTPOSSIBLE*/;
	}

	if(index == 0)
	{
#ifdef __DEBUG_MOVESYS__
		std::cout << "Failure: [Player::__addThing], " << "player: " << getName() << ", index == 0" << std::endl;
		DEBUG_REPORT
#endif
		return /*RET_NOTENOUGHROOM*/;
	}

	Item* item = thing->getItem();
	if(!item)
	{
#ifdef __DEBUG_MOVESYS__
		std::cout << "Failure: [Player::__addThing], " << "player: " << getName() << ", item == NULL" << std::endl;
		DEBUG_REPORT
#endif
		return /*RET_NOTPOSSIBLE*/;
	}

	item->setParent(this);
	inventory[index] = item;

	//send to client
	sendAddInventoryItem((slots_t)index, item);

	//event methods
	onAddInventoryItem((slots_t)index, item);
}

void Player::__updateThing(Thing* thing, uint16_t itemId, uint32_t count)
{
	int32_t index = __getIndexOfThing(thing);
	if(index == -1)
	{
#ifdef __DEBUG_MOVESYS__
		std::cout << "Failure: [Player::__updateThing], " << "player: " << getName() << ", index == -1" << std::endl;
		DEBUG_REPORT
#endif
		return /*RET_NOTPOSSIBLE*/;
	}

	Item* item = thing->getItem();
	if(item == NULL)
	{
#ifdef __DEBUG_MOVESYS__
		std::cout << "Failure: [Player::__updateThing], " << "player: " << getName() << ", item == NULL" << std::endl;
		DEBUG_REPORT
#endif
		return /*RET_NOTPOSSIBLE*/;
	}

	const ItemType& oldType = Item::items[item->getID()];
	const ItemType& newType = Item::items[itemId];

	item->setID(itemId);
	item->setSubType(count);

	//send to client
	sendUpdateInventoryItem((slots_t)index, item, item);
	//event methods
	onUpdateInventoryItem((slots_t)index, item, oldType, item, newType);
}

void Player::__replaceThing(uint32_t index, Thing* thing)
{
	if(index < 0 || index > 13)
	{
#ifdef __DEBUG_MOVESYS__
		std::cout << "Failure: [Player::__replaceThing], " << "player: " << getName() << ", index: " << index << ", index < 0 || index > 13" << std::endl;
		DEBUG_REPORT
#endif
		return /*RET_NOTPOSSIBLE*/;
	}

	Item* oldItem = getInventoryItem((slots_t)index);
	if(!oldItem)
	{
#ifdef __DEBUG_MOVESYS__
		std::cout << "Failure: [Player::__updateThing], " << "player: " << getName() << ", oldItem == NULL" << std::endl;
		DEBUG_REPORT
#endif
		return /*RET_NOTPOSSIBLE*/;
	}

	Item* item = thing->getItem();
	if(!item)
	{
#ifdef __DEBUG_MOVESYS__
		std::cout << "Failure: [Player::__updateThing], " << "player: " << getName() << ", item == NULL" << std::endl;
		DEBUG_REPORT
#endif
		return /*RET_NOTPOSSIBLE*/;
	}

	const ItemType& oldType = Item::items[oldItem->getID()];
	const ItemType& newType = Item::items[item->getID()];

	//send to client
	sendUpdateInventoryItem((slots_t)index, oldItem, item);
	//event methods
	onUpdateInventoryItem((slots_t)index, oldItem, oldType, item, newType);

	item->setParent(this);
	inventory[index] = item;
}

void Player::__removeThing(Thing* thing, uint32_t count)
{
	Item* item = thing->getItem();
	if(!item)
	{
#ifdef __DEBUG_MOVESYS__
		std::cout << "Failure: [Player::__removeThing], " << "player: " << getName() << ", item == NULL" << std::endl;
		DEBUG_REPORT
#endif
		return /*RET_NOTPOSSIBLE*/;
	}

	int32_t index = __getIndexOfThing(thing);
	if(index == -1)
	{
#ifdef __DEBUG_MOVESYS__
		std::cout << "Failure: [Player::__removeThing], " << "player: " << getName() << ", index == -1" << std::endl;
		DEBUG_REPORT
#endif
		return /*RET_NOTPOSSIBLE*/;
	}

	if(item->isStackable())
	{
		if(count == item->getItemCount())
		{
			//send change to client
			sendRemoveInventoryItem((slots_t)index, item);
			//event methods
			onRemoveInventoryItem((slots_t)index, item);

			item->setParent(NULL);
			inventory[index] = NULL;
		}
		else
		{
			item->setItemCount(std::max(0, (int32_t)(item->getItemCount() - count)));
			const ItemType& it = Item::items[item->getID()];

			//send change to client
			sendUpdateInventoryItem((slots_t)index, item, item);
			//event methods
			onUpdateInventoryItem((slots_t)index, item, it, item, it);
		}
	}
	else
	{
		//send change to client
		sendRemoveInventoryItem((slots_t)index, item);
		//event methods
		onRemoveInventoryItem((slots_t)index, item);

		item->setParent(NULL);
		inventory[index] = NULL;
	}
}

Thing* Player::__getThing(uint32_t index) const
{
	if(index > SLOT_PRE_FIRST && index <= 13)
		return inventory[index];

	return NULL;
}

int32_t Player::__getIndexOfThing(const Thing* thing) const
{
	for(int32_t i = SLOT_FIRST; i <= SLOT_LAST; ++i)
	{
		if (i == 11 || i == 12)
			continue;

		if(inventory[i] == thing)
			return i;
	}

	return -1;
}

int32_t Player::__getFirstIndex() const
{
	return SLOT_FIRST;
}

int32_t Player::__getLastIndex() const
{
	return SLOT_LAST;
}

uint32_t Player::__getItemTypeCount(uint16_t itemId, int32_t subType /*= -1*/, bool itemCount /*= true*/) const
{
	Item* item = NULL;
	Container* container = NULL;

	uint32_t count = 0;
	for(int32_t i = SLOT_FIRST; i <= SLOT_LAST; ++i)
	{
		if (i == 11 || i == 12)
			continue;

		if(!(item = inventory[i]))
			continue;

		if(item && item->getID() == itemId)
			count += Item::countByType(item, subType, itemCount);

		if(!(container = item->getContainer()))
			continue;

		// Thalles Vitor
			if (container) {
				for(ContainerIterator it = container->begin(), end = container->end(); it != end; ++it)
				{
					if((*it) && (*it)->getID() == itemId) // Thalles Vitor
						count += Item::countByType(*it, subType, itemCount);
				}
			}
		//
	}

	return count;

}

std::map<uint32_t, uint32_t>& Player::__getAllItemTypeCount(std::map<uint32_t,
	uint32_t>& countMap, bool itemCount/* = true*/) const
{
	Item* item = NULL;
	Container* container = NULL;
	for(int32_t i = SLOT_FIRST; i <= SLOT_LAST; ++i)
	{
		if (i == 11 || i == 12)
			continue;

		if(!(item = inventory[i]))
			continue;

		countMap[item->getID()] += Item::countByType(item, -1, itemCount);
		if(!(container = item->getContainer()))
			continue;

		if (container) {
			for(ContainerIterator it = container->begin(), end = container->end(); it != end; ++it)
				countMap[(*it)->getID()] += Item::countByType(*it, -1, itemCount);
		}
	}

	return countMap;
}

void Player::postAddNotification(Creature* actor, Thing* thing, const Cylinder* oldParent,
	int32_t index, cylinderlink_t link /*= LINK_OWNER*/)
{
	if (!thing)
		return;

	if (thing->isRemoved())
		return;

/* 	Tile* playerTile = getTile();
	if (!playerTile)
		return; */

	if(link == LINK_OWNER) { //calling movement scripts 
		if (thing->getItem()) {
			g_moveEvents->onPlayerEquip(this, thing->getItem(), (slots_t)index, false);
		}
	}

	bool requireListUpdate = true;
	if(link == LINK_OWNER || link == LINK_TOPPARENT)
	{
		updateInventoryWeight();
		updateItemsLight();
		sendStats();
	}

	if (const Item* item = thing->getItem())
	{
		const Container* container = item->getContainer();
		if (container) {
			onSendContainer(container);
		}

		if(shopOwner && requireListUpdate)
			updateInventoryGoods(item->getID());
	}
	else if(const Creature* creature = thing->getCreature())
	{
		if(creature != this)
			return;

		typedef std::vector<Container*> Containers;
		Containers containers;
		for(ContainerVector::iterator it = containerVec.begin(); it != containerVec.end(); ++it)
		{
			if(!Position::areInRange<1,1,0>(it->second->getPosition(), getPosition()))
				containers.push_back(it->second);
		}

		for(Containers::const_iterator it = containers.begin(); it != containers.end(); ++it)
			autoCloseContainers(*it);
	}
}

void Player::postRemoveNotification(Creature* actor, Thing* thing, const Cylinder* newParent,
	int32_t index, bool isCompleteRemoval, cylinderlink_t link /*= LINK_OWNER*/)
{
	if (!thing)
		return;
	
	if(link == LINK_OWNER) //calling movement scripts
		g_moveEvents->onPlayerDeEquip(this, thing->getItem(), (slots_t)index, isCompleteRemoval);

	bool requireListUpdate = true;
	if(link == LINK_OWNER || link == LINK_TOPPARENT)
	{
		if(const Item* item = (newParent ? newParent->getItem() : NULL))
		{
			//assert(item->getContainer() != NULL);
			requireListUpdate = item->getContainer()->getHoldingPlayer() != this;
		}
		else
			requireListUpdate = newParent != this;

		updateInventoryWeight();
		updateItemsLight();
		sendStats();
	}

	if(const Item* item = thing->getItem())
	{
		if(const Container* container = item->getContainer())
		{
			if(container->isRemoved() || !Position::areInRange<1,1,0>(getPosition(), container->getPosition()))
				autoCloseContainers(container);
			else if(container->getTopParent() == this)
				onSendContainer(container);
			else if(const Container* topContainer = dynamic_cast<const Container*>(container->getTopParent()))
			{
				if(const Depot* depot = dynamic_cast<const Depot*>(topContainer))
				{
					bool isOwner = false;
					for(DepotMap::iterator it = depots.begin(); it != depots.end(); ++it)
					{
						if(it->second.first != depot)
							continue;

						isOwner = true;
						onSendContainer(container);
					}

					if(!isOwner)
						autoCloseContainers(container);
				}
				else
					onSendContainer(container);
			}
			else
				autoCloseContainers(container);
		}

		if(shopOwner && requireListUpdate)
			updateInventoryGoods(item->getID());
	}
}

void Player::__internalAddThing(Thing* thing)
{
	__internalAddThing(0, thing);
}

void Player::__internalAddThing(uint32_t index, Thing* thing)
{
#ifdef __DEBUG_MOVESYS__
	std::cout << "[Player::__internalAddThing] index: " << index << std::endl;
#endif

	Item* item = thing->getItem();
	if(!item)
	{
#ifdef __DEBUG_MOVESYS__
		std::cout << "Failure: [Player::__internalAddThing] item == NULL" << std::endl;
#endif
		return;
	}

	//index == 0 means we should equip this item at the most appropiate slot
	if(index == 0)
	{
#ifdef __DEBUG_MOVESYS__
		std::cout << "Failure: [Player::__internalAddThing] index == 0" << std::endl;
		DEBUG_REPORT
#endif
		return;
	}

	if(index > 0 && index < 14)
	{
		if(inventory[index])
		{
#ifdef __DEBUG_MOVESYS__
			std::cout << "Warning: [Player::__internalAddThing], player: " << getName() << ", items[index] is not empty." << std::endl;
			//DEBUG_REPORT
#endif
			return;
		}

		inventory[index] = item;
		item->setParent(this);
	}
}

bool Player::setFollowCreature(Creature* creature, bool fullPathSearch /*= false*/)
{
	bool deny = false;
	CreatureEventList followEvents = getCreatureEvents(CREATURE_EVENT_FOLLOW);
	for(CreatureEventList::iterator it = followEvents.begin(); it != followEvents.end(); ++it)
	{
		if(creature && !(*it)->executeFollow(this, creature))
			deny = true;
	}

	if(deny || !Creature::setFollowCreature(creature, fullPathSearch))
	{
		setFollowCreature(NULL);
		setAttackedCreature(NULL);
		if(!deny)
			sendCancelMessage(RET_THEREISNOWAY);

		sendCancelTarget();
		stopEventWalk();
		return false;
	}

	return true;
}

bool Player::setAttackedCreature(Creature* creature)
{
	if(!Creature::setAttackedCreature(creature))
	{
		sendCancelTarget();
		return false;
	}

	if(chaseMode == CHASEMODE_FOLLOW && creature)
	{
		if(followCreature != creature) //chase opponent
			setFollowCreature(creature);
	}
	else
		setFollowCreature(NULL);

	if(creature)
		Dispatcher::getInstance().addTask(createTask(boost::bind(&Game::checkCreatureAttack, &g_game, getID())));

	return true;
}

void Player::getPathSearchParams(const Creature* creature, FindPathParams& fpp) const
{
	Creature::getPathSearchParams(creature, fpp);
	fpp.fullPathSearch = true;
}

void Player::doAttacking(uint32_t interval)
{
	if(!lastAttack)
		lastAttack = OTSYS_TIME() - getAttackSpeed() - 1;
	else if((OTSYS_TIME() - lastAttack) < getAttackSpeed())
		return;

	if(hasCondition(CONDITION_PACIFIED) && !hasCustomFlag(PlayerCustomFlag_IgnorePacification))
	{
		lastAttack = OTSYS_TIME();
		return;
	}

	Item* tool = getWeapon();
	if(const Weapon* weapon = g_weapons->getWeapon(tool))
	{
		if(weapon->interruptSwing() && !canDoAction())
		{
			SchedulerTask* task = createSchedulerTask(getNextActionTime(), boost::bind(&Game::checkCreatureAttack, &g_game, getID()));
			setNextActionTask(task);
		}
		else if((!weapon->hasExhaustion() || !hasCondition(CONDITION_EXHAUST, EXHAUST_COMBAT)) && weapon->useWeapon(this, tool, attackedCreature))
			lastAttack = OTSYS_TIME();
	}
	else if(Weapon::useFist(this, attackedCreature))
		lastAttack = OTSYS_TIME();
}

double Player::getGainedExperience(Creature* attacker) const
{
	if(!skillLoss)
		return 0;

	double rate = g_config.getDouble(ConfigManager::RATE_PVP_EXPERIENCE);
	if(rate <= 0)
		return 0;

	Player* attackerPlayer = attacker->getPlayer();
	if(!attackerPlayer || attackerPlayer == this)
		return 0;

	double attackerLevel = (double)attackerPlayer->getLevel(), min = g_config.getDouble(
		ConfigManager::EFP_MIN_THRESHOLD), max = g_config.getDouble(ConfigManager::EFP_MAX_THRESHOLD);
	if((min > 0 && level < (uint32_t)std::floor(attackerLevel * min)) || (max > 0 &&
		level > (uint32_t)std::floor(attackerLevel * max)))
		return 0;

	/*
		Formula
		a = attackers level * 0.9
		b = victims level
		c = victims experience

		result = (1 - (a / b)) * 0.05 * c
		Not affected by special multipliers(!)
	*/
	uint32_t a = (uint32_t)std::floor(attackerLevel * 0.9), b = level;
	uint64_t c = getExperience();
	return (double)std::max((uint64_t)0, (uint64_t)std::floor(getDamageRatio(attacker)
		* std::max((double)0, ((double)(1 - (((double)a / b))))) * 0.05 * c)) * rate;
}

void Player::onFollowCreature(const Creature* creature)
{
	if(!creature)
		stopEventWalk();
}

void Player::setChaseMode(chaseMode_t mode)
{
	chaseMode_t prevChaseMode = chaseMode;
	chaseMode = mode;

	if(prevChaseMode == chaseMode)
		return;

	if(chaseMode == CHASEMODE_FOLLOW)
	{
		if(!followCreature && attackedCreature) //chase opponent
			setFollowCreature(attackedCreature);
	}
	else if(attackedCreature)
	{
		setFollowCreature(NULL);
		stopEventWalk();
	}
}

void Player::onWalkAborted()
{
	setNextWalkActionTask(NULL);
	sendCancelWalk();
}

void Player::onWalkComplete()
{
	if(!walkTask)
		return;

	walkTaskEvent = Scheduler::getInstance().addEvent(walkTask);
	walkTask = NULL;
}

void Player::stopWalk()
{
	if(listWalkDir.empty())
		return;

	stopEventWalk();
}

void Player::getCreatureLight(LightInfo& light) const
{
	if(internalLight.level > itemsLight.level)
		light = internalLight;
	else
		light = itemsLight;
}

void Player::updateItemsLight(bool internal /*=false*/)
{
	LightInfo maxLight;
	LightInfo curLight;
	for(int32_t i = SLOT_FIRST; i <= SLOT_LAST; ++i)
	{
		if (i == 11 || i == 12)
			continue;

		if(Item* item = getInventoryItem((slots_t)i))
		{
			item->getLight(curLight);
			if(curLight.level > maxLight.level)
				maxLight = curLight;
		}
	}
	if(itemsLight.level != maxLight.level || itemsLight.color != maxLight.color)
	{
		itemsLight = maxLight;
		if(!internal)
			g_game.changeLight(this);
	}
}

void Player::onAddCondition(ConditionType_t type, bool hadCondition)
{
	Creature::onAddCondition(type, hadCondition);
	if(getLastPosition().x && type != CONDITION_GAMEMASTER) // don't send if player have just logged in (its already done in protocolgame), or condition have no icons
		sendIcons();
}

void Player::onAddCombatCondition(ConditionType_t type, bool hadCondition)
{
	std::string tmp;
	switch(type)
	{
		//client hardcoded
		case CONDITION_FIRE:
			tmp = "burning";
			break;
		case CONDITION_BUG:
			tmp = "dashing";
			break;
		case CONDITION_FLY:
			tmp = "dashing";
			break;
		case CONDITION_DRAGON:
			tmp = "dashing";
			break;
		case CONDITION_VENOM:
			tmp = "dashing";
			break;
		case CONDITION_TEST:
			tmp = "dashing";
			break;
		case CONDITION_FIGHT:
			tmp = "dashing";
			break;
		case CONDITION_ROCK:
			tmp = "dashing";
			break;
		case CONDITION_ELECTRIC:
			tmp = "dashing";
			break;
		case CONDITION_POISON:
			tmp = "poisoned";
			break;
		case CONDITION_ENERGY:
			tmp = "electrified";
			break;
		case CONDITION_FREEZING:
			tmp = "freezing";
			break;
		case CONDITION_DAZZLED:
			tmp = "dazzled";
			break;
		case CONDITION_CURSED:
			tmp = "cursed";
			break;
		case CONDITION_DROWN:
			tmp = "drowning";
			break;
		case CONDITION_DRUNK:
			tmp = "drunk";
			break;
		case CONDITION_MANASHIELD:
			tmp = "protected by a magic shield";
			break;
		case CONDITION_PARALYZE:
			tmp = "paralyzed";
			break;
		case CONDITION_HASTE:
			tmp = "hasted";
			break;
		case CONDITION_ATTRIBUTES:
			tmp = "strengthened";
			break;
		default:
			break;
	}

	if(!tmp.empty())
		sendTextMessage(MSG_STATUS_DEFAULT, "You are " + tmp + ".");
}

void Player::onEndCondition(ConditionType_t type)
{
	Creature::onEndCondition(type);
	if(type == CONDITION_INFIGHT)
	{
		onIdleStatus();
		clearAttacked();

		pzLocked = false;
		if(skull < SKULL_RED)
			setSkull(SKULL_NONE);

		g_game.updateCreatureSkull(this);
	}

	sendIcons();
}

void Player::onCombatRemoveCondition(const Creature* attacker, Condition* condition)
{
	//Creature::onCombatRemoveCondition(attacker, condition);
	bool remove = true;
	if(condition->getId() > 0)
	{
		remove = false;
		//Means the condition is from an item, id == slot
		if(g_game.getWorldType() == WORLD_TYPE_PVP_ENFORCED)
		{
			if(Item* item = getInventoryItem((slots_t)condition->getId()))
			{
				//25% chance to destroy the item
				if(25 >= random_range(0, 100))
					g_game.internalRemoveItem(NULL, item);
			}
		}
	}

	if(remove)
	{
		if(!canDoAction())
		{
			uint32_t delay = getNextActionTime();
			delay -= (delay % EVENT_CREATURE_THINK_INTERVAL);
			if(delay < 0)
				removeCondition(condition);
			else
				condition->setTicks(delay);
		}
		else
			removeCondition(condition);
	}
}

void Player::onTickCondition(ConditionType_t type, int32_t interval, bool& _remove)
{
	Creature::onTickCondition(type, interval, _remove);
	if(type == CONDITION_HUNTING)
		useStamina(-(interval * g_config.getNumber(ConfigManager::RATE_STAMINA_LOSS)));
}

void Player::onAttackedCreature(Creature* target)
{
	Creature::onAttackedCreature(target);
	if(hasFlag(PlayerFlag_NotGainInFight))
		return;

	addInFightTicks();
	Player* targetPlayer = target->getPlayer();
	if(!targetPlayer)
		return;

	addAttacked(targetPlayer);
	if(targetPlayer == this && targetPlayer->getZone() != ZONE_PVP)
	{
		targetPlayer->sendCreatureSkull(this);
		return;
	}

	if(Combat::isInPvpZone(this, targetPlayer) || isPartner(targetPlayer) || (g_config.getBool(
		ConfigManager::ALLOW_FIGHTBACK) && targetPlayer->hasAttacked(this)))
		return;

	if(!pzLocked)
	{
		pzLocked = true;
		sendIcons();
	}

	if(getZone() != target->getZone())
		return;

	if(skull == SKULL_NONE)
	{
		if(targetPlayer->getSkull() != SKULL_NONE)
			targetPlayer->sendCreatureSkull(this);
		/* else if(!hasCustomFlag(PlayerCustomFlag_NotGainSkull))
		{
			setSkull(SKULL_WHITE);
			g_game.updateCreatureSkull(this);
		} */
	}
}

void Player::onSummonAttackedCreature(Creature* summon, Creature* target)
{
	Creature::onSummonAttackedCreature(summon, target);
	onAttackedCreature(target);
}

void Player::onAttacked()
{
	Creature::onAttacked();
	addInFightTicks();
}

bool Player::checkLoginDelay(uint32_t playerId) const
{
	return (!hasCustomFlag(PlayerCustomFlag_IgnoreLoginDelay) && OTSYS_TIME() <= (lastLoad + g_config.getNumber(
		ConfigManager::LOGIN_PROTECTION)) && !hasBeenAttacked(playerId));
}

void Player::onIdleStatus()
{
	Creature::onIdleStatus();
	if(getParty())
		getParty()->clearPlayerPoints(this);
}

void Player::onPlacedCreature()
{
	//scripting event - onLogin
	if(!g_creatureEvents->playerLogin(this))
		kickPlayer(true, true);
}

void Player::onAttackedCreatureDrain(Creature* target, int32_t points)
{
	Creature::onAttackedCreatureDrain(target, points);
	if(party && target && (!target->getMaster() || !target->getMaster()->getPlayer())
		&& target->getMonster() && target->getMonster()->isHostile()) //we have fulfilled a requirement for shared experience
		getParty()->addPlayerDamageMonster(this, points);

	char buffer[100];
	sprintf(buffer, "Your pokemon dealt %d damage to %s.", points, target->getNameDescription().c_str());
	sendTextMessage(MSG_STATUS_DEFAULT, buffer);
}

void Player::onSummonAttackedCreatureDrain(Creature* summon, Creature* target, int32_t points)
{
	Creature::onSummonAttackedCreatureDrain(summon, target, points);

	char buffer[100];
	sprintf(buffer, "Your %s deals %d damage to %s.", summon->getName().c_str(), points, target->getNameDescription().c_str());
	sendTextMessage(MSG_EVENT_DEFAULT, buffer);
}

void Player::onTargetCreatureGainHealth(Creature* target, int32_t points)
{
	Creature::onTargetCreatureGainHealth(target, points);
	if(target && getParty())
	{
		Player* tmpPlayer = NULL;
		if(target->getPlayer())
			tmpPlayer = target->getPlayer();
		else if(target->getMaster() && target->getMaster()->getPlayer())
			tmpPlayer = target->getMaster()->getPlayer();

		if(isPartner(tmpPlayer))
			getParty()->addPlayerHealedMember(this, points);
	}
}

bool Player::onKilledCreature(Creature* target, uint32_t& flags)
{
	if(!Creature::onKilledCreature(target, flags))
		return false;

	/* if(hasFlag(PlayerFlag_NotGenerateLoot))
		target->setDropLoot(LOOT_DROP_NONE); */

	Condition* condition = NULL;
	if(target->getMonster() && !target->isPlayerSummon() && !hasFlag(PlayerFlag_HasInfiniteStamina)
		&& (condition = Condition::createCondition(CONDITIONID_DEFAULT, CONDITION_HUNTING,
		g_config.getNumber(ConfigManager::HUNTING_DURATION))))
		addCondition(condition);

	if(hasFlag(PlayerFlag_NotGainInFight) || !hasBitSet((uint32_t)KILLFLAG_JUSTIFY, flags) || getZone() != target->getZone())
		return true;

	Player* targetPlayer = target->getPlayer();
	if(!targetPlayer || Combat::isInPvpZone(this, targetPlayer) || !hasCondition(CONDITION_INFIGHT) || isPartner(targetPlayer))
		return true;

	if(!targetPlayer->hasAttacked(this) && target->getSkull() == SKULL_NONE && targetPlayer != this
		&& ((g_config.getBool(ConfigManager::USE_FRAG_HANDLER) && addUnjustifiedKill(
		targetPlayer)) || hasBitSet((uint32_t)KILLFLAG_LASTHIT, flags)))
		flags |= (uint32_t)KILLFLAG_UNJUSTIFIED;

	pzLocked = true;
	if((condition = Condition::createCondition(CONDITIONID_DEFAULT, CONDITION_INFIGHT,
		g_config.getNumber(ConfigManager::WHITE_SKULL_TIME))))
		addCondition(condition);

	return true;
}

bool Player::gainExperience(double& gainExp, bool fromMonster)
{
	if(!rateExperience(gainExp, fromMonster))
		return false;

	//soul regeneration
	if(gainExp >= level)
	{
		if(Condition* condition = Condition::createCondition(
			CONDITIONID_DEFAULT, CONDITION_SOUL, 4 * 60 * 1000))
		{
			condition->setParam(CONDITIONPARAM_SOULGAIN,
				vocation->getGainAmount(GAIN_SOUL));
			condition->setParam(CONDITIONPARAM_SOULTICKS,
				(vocation->getGainTicks(GAIN_SOUL) * 1000));
			addCondition(condition);
		}
	}

	addExperience((uint64_t)gainExp);
	return true;
}

bool Player::rateExperience(double& gainExp, bool fromMonster)
{
	if(hasFlag(PlayerFlag_NotGainExperience) || gainExp <= 0)
		return false;

	if(!fromMonster)
		return true;

	gainExp *= rates[SKILL__LEVEL] * g_game.getExperienceStage(level,
		vocation->getExperienceMultiplier());
	if(!hasFlag(PlayerFlag_HasInfiniteStamina))
	{
		int32_t minutes = getStaminaMinutes();
		if(minutes >= g_config.getNumber(ConfigManager::STAMINA_LIMIT_TOP))
		{
			if(isPremium() || !g_config.getNumber(ConfigManager::STAMINA_BONUS_PREMIUM))
				gainExp *= g_config.getDouble(ConfigManager::RATE_STAMINA_ABOVE);
		}
		else if(minutes < (g_config.getNumber(ConfigManager::STAMINA_LIMIT_BOTTOM)) && minutes > 0)
			gainExp *= g_config.getDouble(ConfigManager::RATE_STAMINA_UNDER);
		else if(minutes <= 0)
			gainExp = 0;
	}
	else if(isPremium() || !g_config.getNumber(ConfigManager::STAMINA_BONUS_PREMIUM))
		gainExp *= g_config.getDouble(ConfigManager::RATE_STAMINA_ABOVE);

	return true;
}

void Player::onGainExperience(double& gainExp, bool fromMonster, bool multiplied)
{
	if(party && party->isSharedExperienceEnabled() && party->isSharedExperienceActive())
	{
		party->shareExperience(gainExp, fromMonster, multiplied);
		rateExperience(gainExp, fromMonster);
		return; //we will get a share of the experience through the sharing mechanism
	}

	if(gainExperience(gainExp, fromMonster))
		Creature::onGainExperience(gainExp, fromMonster, true);
}

void Player::onGainSharedExperience(double& gainExp, bool fromMonster, bool multiplied)
{
	if(gainExperience(gainExp, fromMonster))
		Creature::onGainSharedExperience(gainExp, fromMonster, true);
}

bool Player::isImmune(CombatType_t type) const
{
	return hasCustomFlag(PlayerCustomFlag_IsImmune) || Creature::isImmune(type);
}

bool Player::isImmune(ConditionType_t type) const
{
	return hasCustomFlag(PlayerCustomFlag_IsImmune) || Creature::isImmune(type);
}

bool Player::isAttackable() const
{
	return (!hasFlag(PlayerFlag_CannotBeAttacked) && !isAccountManager());
}

void Player::changeHealth(int32_t healthChange)
{
	Creature::changeHealth(healthChange);
	sendStats();
}

void Player::changeMana(int32_t manaChange)
{
	if(!hasFlag(PlayerFlag_HasInfiniteMana))
		Creature::changeMana(manaChange);

	sendStats();
}

void Player::changeSoul(int32_t soulChange)
{
	if(!hasFlag(PlayerFlag_HasInfiniteSoul))
		soul = std::min((int32_t)soulMax, (int32_t)soul + soulChange);

	sendStats();
}

bool Player::canLogout(bool checkInfight)
{
	if(checkInfight && hasCondition(CONDITION_INFIGHT))
		return false;

	return !isConnecting && !pzLocked && !getTile()->hasFlag(TILESTATE_NOLOGOUT);
}

bool Player::changeOutfit(Outfit_t outfit, bool checkList)
{
	uint32_t outfitId = Outfits::getInstance()->getOutfitId(outfit.lookType);
	if(checkList && (!canWearOutfit(outfitId, outfit.lookAddons) || !requestedOutfit))
		return false;

	requestedOutfit = false;
	if(outfitAttributes)
	{
		uint32_t oldId = Outfits::getInstance()->getOutfitId(defaultOutfit.lookType);
		outfitAttributes = !Outfits::getInstance()->removeAttributes(getID(), oldId, sex);
	}

	defaultOutfit = outfit;
	outfitAttributes = Outfits::getInstance()->addAttributes(getID(), outfitId, sex, defaultOutfit.lookAddons);
	return true;
}

bool Player::canWearOutfit(uint32_t outfitId, uint32_t addons)
{
	OutfitMap::iterator it = outfits.find(outfitId);
	if(it == outfits.end() || getAccess() < it->second.accessLevel)
		return false;

	if(!it->second.storageId)
		return true;

	std::string value;
	return getStorage(it->second.storageId, value) && value == it->second.storageValue;
}

bool Player::addOutfit(uint32_t outfitId, uint32_t addons)
{
	Outfit outfit;
	if(!Outfits::getInstance()->getOutfit(outfitId, sex, outfit))
		return false;

	OutfitMap::iterator it = outfits.find(outfitId);
	if(it != outfits.end())
		outfit.addons |= it->second.addons;

	outfit.addons |= addons;
	outfits[outfitId] = outfit;
	return true;
}

bool Player::removeOutfit(uint32_t outfitId, uint32_t addons)
{
	OutfitMap::iterator it = outfits.find(outfitId);
	if(it == outfits.end())
		return false;

	if(addons == 0xFF) //remove outfit
		outfits.erase(it);
	else //remove addons
		outfits[outfitId].addons = it->second.addons & (~addons);

	return true;
}

void Player::generateReservedStorage()
{
	uint32_t baseKey = PSTRG_OUTFITSID_RANGE_START + 1;
	const OutfitMap& defaultOutfits = Outfits::getInstance()->getOutfits(sex);
	for(OutfitMap::const_iterator it = outfits.begin(); it != outfits.end(); ++it)
	{
		OutfitMap::const_iterator dit = defaultOutfits.find(it->first);
		if(dit == defaultOutfits.end() || (dit->second.isDefault && (dit->second.addons
			& it->second.addons) == it->second.addons))
			continue;

		std::stringstream ss;
		ss << ((it->first << 16) | (it->second.addons & 0xFF));
		storageMap[baseKey] = ss.str();

		baseKey++;
		if(baseKey <= PSTRG_OUTFITSID_RANGE_START + PSTRG_OUTFITSID_RANGE_SIZE)
			continue;

		std::cout << "[Warning - Player::genReservedStorageRange] Player " << getName() << " with more than 500 outfits!" << std::endl;
		break;
	}
}

void Player::setSex(uint16_t newSex)
{
	sex = newSex;
	const OutfitMap& defaultOutfits = Outfits::getInstance()->getOutfits(sex);
	for(OutfitMap::const_iterator it = defaultOutfits.begin(); it != defaultOutfits.end(); ++it)
	{
		if(it->second.isDefault)
			addOutfit(it->first, it->second.addons);
	}
}

Skulls_t Player::getSkull() const
{
	/* if(hasFlag(PlayerFlag_NotGainInFight) || hasCustomFlag(PlayerCustomFlag_NotGainSkull))
		return SKULL_NONE; */

	return skull;
}

Skulls_t Player::getSkullClient(const Creature* creature) const
{
	if(const Player* player = creature->getPlayer())
	{
		/* if(g_game.getWorldType() != WORLD_TYPE_PVP)
			return SKULL_NONE; */

		/* if((player == this || (skull != SKULL_NONE && player->getSkull() < SKULL_RED)) && player->hasAttacked(this))
			return SKULL_YELLOW; */

		if(player->getSkull() == SKULL_NONE && isPartner(player) && g_game.getWorldType() != WORLD_TYPE_NO_PVP)
			return SKULL_GREEN;
	}

	return Creature::getSkullClient(creature);
}

bool Player::hasAttacked(const Player* attacked) const
{
	return !hasFlag(PlayerFlag_NotGainInFight) && attacked &&
		attackedSet.find(attacked->getID()) != attackedSet.end();
}

void Player::addAttacked(const Player* attacked)
{
	if(hasFlag(PlayerFlag_NotGainInFight) || !attacked)
		return;

	uint32_t attackedId = attacked->getID();
	if(attackedSet.find(attackedId) == attackedSet.end())
		attackedSet.insert(attackedId);
}

void Player::setSkullEnd(time_t _time, bool login, Skulls_t _skull)
{
	if(g_game.getWorldType() == WORLD_TYPE_PVP_ENFORCED)
		return;

	bool requireUpdate = false;
	if(_time > time(NULL))
	{
		requireUpdate = true;
		setSkull(_skull);
	}
	else if(skull == _skull)
	{
		requireUpdate = true;
		setSkull(SKULL_NONE);
		_time = 0;
	}

	if(requireUpdate)
	{
		skullEnd = _time;
		if(!login)
			g_game.updateCreatureSkull(this);
	}
}

bool Player::addUnjustifiedKill(const Player* attacked)
{
	if(g_game.getWorldType() == WORLD_TYPE_PVP_ENFORCED || attacked == this || hasFlag(
		PlayerFlag_NotGainInFight) || hasCustomFlag(PlayerCustomFlag_NotGainSkull))
		return false;

	if(client)
	{
		char buffer[90];
		sprintf(buffer, "Warning! The murder of %s was not justified.",
			attacked->getName().c_str());
		client->sendTextMessage(MSG_STATUS_WARNING, buffer);
	}

	time_t now = time(NULL), today = (now - 84600), week = (now - (7 * 84600));
	std::vector<time_t> dateList;
	IOLoginData::getInstance()->getUnjustifiedDates(guid, dateList, now);

	dateList.push_back(now);
	uint32_t tc = 0, wc = 0, mc = dateList.size();
	for(std::vector<time_t>::iterator it = dateList.begin(); it != dateList.end(); ++it)
	{
		if((*it) > week)
			wc++;

		if((*it) > today)
			tc++;
	}

	uint32_t d = g_config.getNumber(ConfigManager::RED_DAILY_LIMIT), w = g_config.getNumber(
		ConfigManager::RED_WEEKLY_LIMIT), m = g_config.getNumber(ConfigManager::RED_MONTHLY_LIMIT);
	if(skull < SKULL_RED && ((d > 0 && tc >= d) || (w > 0 && wc >= w) || (m > 0 && mc >= m)))
		setSkullEnd(now + g_config.getNumber(ConfigManager::RED_SKULL_LENGTH), false, SKULL_RED);

	if(!g_config.getBool(ConfigManager::USE_BLACK_SKULL))
	{
		d += g_config.getNumber(ConfigManager::BAN_DAILY_LIMIT);
		w += g_config.getNumber(ConfigManager::BAN_WEEKLY_LIMIT);
		m += g_config.getNumber(ConfigManager::BAN_MONTHLY_LIMIT);
		if((d <= 0 || tc < d) && (w <= 0 || wc < w) && (m <= 0 || mc < m))
			return true;

		if(!IOBan::getInstance()->addAccountBanishment(accountId, (now + g_config.getNumber(
			ConfigManager::KILLS_BAN_LENGTH)), 20, ACTION_BANISHMENT, "Unjustified player killing.", 0, guid))
			return true;

		sendTextMessage(MSG_INFO_DESCR, "You have been banished.");
		g_game.addMagicEffect(getPosition(), MAGIC_EFFECT_WRAPS_GREEN);
		Scheduler::getInstance().addEvent(createSchedulerTask(1000, boost::bind(
			&Game::kickPlayer, &g_game, getID(), false)));
	}
	else
	{
		d += g_config.getNumber(ConfigManager::BLACK_DAILY_LIMIT);
		w += g_config.getNumber(ConfigManager::BLACK_WEEKLY_LIMIT);
		m += g_config.getNumber(ConfigManager::BLACK_MONTHLY_LIMIT);
		if(skull < SKULL_BLACK && ((d > 0 && tc >= d) || (w > 0 && wc >= w) || (m > 0 && mc >= m)))
		{
			setSkullEnd(now + g_config.getNumber(ConfigManager::BLACK_SKULL_LENGTH), false, SKULL_BLACK);
			setAttackedCreature(NULL);
			destroySummons();
		}
	}

	return true;
}

void Player::setPromotionLevel(uint32_t pLevel)
{
	if(pLevel > promotionLevel)
	{
		uint32_t tmpLevel = 0, currentVoc = vocation_id;
		for(uint32_t i = promotionLevel; i < pLevel; ++i)
		{
			currentVoc = Vocations::getInstance()->getPromotedVocation(currentVoc);
			if(!currentVoc)
				break;

			tmpLevel++;
			Vocation* voc = Vocations::getInstance()->getVocation(currentVoc);
			if(voc->isPremiumNeeded() && !isPremium() && g_config.getBool(ConfigManager::PREMIUM_FOR_PROMOTION))
				continue;

			vocation_id = currentVoc;
		}

		promotionLevel += tmpLevel;
	}
	else if(pLevel < promotionLevel)
	{
		uint32_t tmpLevel = 0, currentVoc = vocation_id;
		for(uint32_t i = pLevel; i < promotionLevel; ++i)
		{
			Vocation* voc = Vocations::getInstance()->getVocation(currentVoc);
			if(voc->getFromVocation() == currentVoc)
				break;

			tmpLevel++;
			currentVoc = voc->getFromVocation();
			if(voc->isPremiumNeeded() && !isPremium() && g_config.getBool(ConfigManager::PREMIUM_FOR_PROMOTION))
				continue;

			vocation_id = currentVoc;
		}

		promotionLevel -= tmpLevel;
	}

	setVocation(vocation_id);
}

uint16_t Player::getBlessings() const
{
	if(!isPremium() && g_config.getBool(ConfigManager::BLESSING_ONLY_PREMIUM))
		return 0;

	uint16_t count = 0;
	for(int16_t i = 0; i < 16; ++i)
	{
		if(hasBlessing(i))
			count++;
	}

	return count;
}

uint64_t Player::getLostExperience() const
{
	if(!skillLoss)
		return 0;

	double percent = (double)(lossPercent[LOSS_EXPERIENCE] - vocation->getLessLoss() - (getBlessings() * g_config.getNumber(
		ConfigManager::BLESS_REDUCTION))) / 100.;
	if(level <= 25)
		return (uint64_t)std::floor((double)(experience * percent) / 10.);

	int32_t base = level;
	double levels = (double)(base + 50) / 100.;

	uint64_t lost = 0;
	while(levels > 1.0f)
	{
		lost += (getExpForLevel(base) - getExpForLevel(base - 1));
		base--;
		levels -= 1.;
	}

	if(levels > 0.)
		lost += (uint64_t)std::floor((double)(getExpForLevel(base) - getExpForLevel(base - 1)) * levels);

	return (uint64_t)std::floor((double)(lost * percent));
}

uint32_t Player::getAttackSpeed()
{
	Item* weapon = getWeapon();
	if(weapon && weapon->getAttackSpeed() != 0)
		return weapon->getAttackSpeed();

	return vocation->getAttackSpeed();
}

void Player::learnInstantSpell(const std::string& name)
{
	if(!hasLearnedInstantSpell(name))
		learnedInstantSpellList.push_back(name);
}

void Player::unlearnInstantSpell(const std::string& name)
{
	if(!hasLearnedInstantSpell(name))
		return;

	LearnedInstantSpellList::iterator it = std::find(learnedInstantSpellList.begin(), learnedInstantSpellList.end(), name);
	if(it != learnedInstantSpellList.end())
		learnedInstantSpellList.erase(it);
}

bool Player::hasLearnedInstantSpell(const std::string& name) const
{
	if(hasFlag(PlayerFlag_CannotUseSpells))
		return false;

	if(hasFlag(PlayerFlag_IgnoreSpellCheck))
		return true;

	for(LearnedInstantSpellList::const_iterator it = learnedInstantSpellList.begin(); it != learnedInstantSpellList.end(); ++it)
	{
		if(!strcasecmp((*it).c_str(), name.c_str()))
			return true;
	}

	return false;
}

bool Player::isGuildInvited(uint32_t guildId) const
{
	for(InvitedToGuildsList::const_iterator it = invitedToGuildsList.begin(); it != invitedToGuildsList.end(); ++it)
	{
		if((*it) == guildId)
			return true;
	}

	return false;
}

void Player::leaveGuild()
{
	sendClosePrivate(CHANNEL_GUILD);
	guildLevel = GUILDLEVEL_NONE;
	guildId = rankId = 0;
	guildName = rankName = guildNick = "";
}

bool Player::isPremium() const
{
	if(g_config.getBool(ConfigManager::FREE_PREMIUM) || hasFlag(PlayerFlag_IsAlwaysPremium))
		return true;

	return premiumDays;
}

bool Player::setGuildLevel(GuildLevel_t newLevel, uint32_t rank/* = 0*/)
{
	std::string name;
	if(!IOGuild::getInstance()->getRankEx(rank, name, guildId, newLevel))
		return false;

	guildLevel = newLevel;
	rankName = name;
	rankId = rank;
	return true;
}

void Player::setGroupId(int32_t newId)
{
	if(Group* tmp = Groups::getInstance()->getGroup(newId))
	{
		groupId = newId;
		group = tmp;
	}
}

void Player::setGroup(Group* newGroup)
{
	if(newGroup)
	{
		group = newGroup;
		groupId = group->getId();
	}
}

PartyShields_t Player::getPartyShield(const Creature* creature) const
{
	const Player* player = creature->getPlayer();
	if(!player)
		return Creature::getPartyShield(creature);

	if(Party* party = getParty())
	{
		if(party->getLeader() == player)
		{
			if(party->isSharedExperienceActive())
			{
				if(party->isSharedExperienceEnabled())
					return SHIELD_YELLOW_SHAREDEXP;

				if(party->canUseSharedExperience(player))
					return SHIELD_YELLOW_NOSHAREDEXP;

				return SHIELD_YELLOW_NOSHAREDEXP_BLINK;
			}

			return SHIELD_YELLOW;
		}

		if(party->isPlayerMember(player))
		{
			if(party->isSharedExperienceActive())
			{
				if(party->isSharedExperienceEnabled())
					return SHIELD_BLUE_SHAREDEXP;

				if(party->canUseSharedExperience(player))
					return SHIELD_BLUE_NOSHAREDEXP;

				return SHIELD_BLUE_NOSHAREDEXP_BLINK;
			}

			return SHIELD_BLUE;
		}

		if(isInviting(player))
			return SHIELD_WHITEBLUE;
	}

	if(player->isInviting(this))
		return SHIELD_WHITEYELLOW;

	return SHIELD_NONE;
}

bool Player::isInviting(const Player* player) const
{
	if(!player || !getParty() || getParty()->getLeader() != this)
		return false;

	return getParty()->isPlayerInvited(player);
}

bool Player::isPartner(const Player* player) const
{
	if(!player || !getParty() || !player->getParty())
		return false;

	return (getParty() == player->getParty());
}

void Player::sendPlayerPartyIcons(Player* player)
{
	sendCreatureShield(player);
	sendCreatureSkull(player);
}

bool Player::addPartyInvitation(Party* party)
{
	if(!party)
		return false;

	PartyList::iterator it = std::find(invitePartyList.begin(), invitePartyList.end(), party);
	if(it != invitePartyList.end())
		return false;

	invitePartyList.push_back(party);
	return true;
}

bool Player::removePartyInvitation(Party* party)
{
	if(!party)
		return false;

	PartyList::iterator it = std::find(invitePartyList.begin(), invitePartyList.end(), party);
	if(it != invitePartyList.end())
	{
		invitePartyList.erase(it);
		return true;
	}
	return false;
}

void Player::clearPartyInvitations()
{
	if(invitePartyList.empty())
		return;

	PartyList list;
	for(PartyList::iterator it = invitePartyList.begin(); it != invitePartyList.end(); ++it)
		list.push_back(*it);

	invitePartyList.clear();
	for(PartyList::iterator it = list.begin(); it != list.end(); ++it)
		(*it)->removeInvite(this);
}

void Player::increaseCombatValues(int32_t& min, int32_t& max, bool useCharges, bool countWeapon)
{
	if(min > 0)
		min = (int32_t)(min * vocation->getMultiplier(MULTIPLIER_HEALING));
	else
		min = (int32_t)(min * vocation->getMultiplier(MULTIPLIER_MAGIC));

	if(max > 0)
		max = (int32_t)(max * vocation->getMultiplier(MULTIPLIER_HEALING));
	else
		max = (int32_t)(max * vocation->getMultiplier(MULTIPLIER_MAGIC));

	int32_t minValue = 0, maxValue = 0;
	min += minValue;
	max += maxValue;
}

bool Player::transferMoneyTo(const std::string& name, uint64_t amount)
{
	if(!g_config.getBool(ConfigManager::BANK_SYSTEM) || amount > balance)
		return false;

	Player* target = g_game.getPlayerByNameEx(name);
	if(!target)
		return false;

	balance -= amount;
	target->balance += amount;
	if(target->isVirtual())
	{
		IOLoginData::getInstance()->savePlayer(target);
		delete target;
	}

	return true;
}

void Player::sendCritical() const
{
	if(g_config.getBool(ConfigManager::DISPLAY_CRITICAL_HIT))
		g_game.addAnimatedText(getPosition(), TEXTCOLOR_DARKRED, "CRITICAL!");
}

// Thalles Vitor - Market System
void Player::receiveMarketItem(uint16_t index)
{
	Item* backpack = getInventoryItem((slots_t)SLOT_BACKPACK);
	if (!backpack) {
		return;
	}

	Container* container = backpack->getContainer();
	if (!container) {
		return;
	}

    //std::cout << index << std::endl;
	if (Item* item = container->getItem(index)) {
		if (item->getWorth() != 0) {
			//sendFYIBox("Voce nao pode anunciar dinheiro.");
			return;
		}

		Container* container = item->getContainer();
		if (container) {
			uint32_t itemsCount = 0;
			for(ContainerIterator it = container->begin(), end = container->end(); it != end; ++it)
			{
				++itemsCount;
			}

			if (itemsCount > 0) {
				sendFYIBox("Voce nao pode vender backpacks, depots ou outros com items dentro.");
				return;
			}
		}
		
		CreatureEventList events = getCreatureEvents(CREATURE_EVENT_INSERT_MARKETITEM);
		for(CreatureEventList::iterator it = events.begin(); it != events.end(); ++it) {
			(*it)->executeMarketInsert(this, item);
		}
	}
}

bool Player::removeMarketItem(uint16_t integgerAttribute, uint16_t amount, uint64_t price, uint16_t gender, uint16_t level, std::string ispokemon, std::string name, bool onlyoffers)
{
	Item* backpack = getInventoryItem((slots_t)SLOT_BACKPACK);
	if (!backpack) {
		return false;
	}

	Container* container = backpack->getContainer();
	if (!container) {
		return false;
	}

	uint64_t newPrice = price; // price*100
	
	if (g_game.getMoney(this) < newPrice) {
		sendFYIBox("Voce nao possui dinheiro suficiente para anunciar este produto.");
		return false;
	}

	Database* db = Database::getInstance();
	std::ostringstream query;
	DBResult* result = NULL;

	uint16_t count_row = 0;
	uint16_t count_row2 = 0;
	uint16_t total_transactions = 0;
	uint16_t page_counts = 0;

	query.str("");
	query << "SELECT COUNT(*) FROM `players_mymarketoffers` WHERE `player_id` = " << getGUID() << ";";
	if ((result = db->storeQuery(query.str()))) {
		count_row = result->getDataInt("COUNT(*)") + 1;
	}

	query.str("");
	query << "SELECT COUNT(*) FROM `players_marketoffers` WHERE `player_id` = " << getGUID() << ";";
	if ((result = db->storeQuery(query.str()))) {
		count_row2 = result->getDataInt("COUNT(*)") + 1;
	}
	
	query.str("");
	query << "SELECT COUNT(*) FROM `players_marketoffers`" << ";";
	if ((result = db->storeQuery(query.str()))) {
		total_transactions = total_transactions + result->getDataInt("COUNT(*)") + 1;
	}
	
	query.str("");
	query << "SELECT `page_numeration` FROM `players_marketoffers` ORDER BY page_numeration DESC LIMIT 1;";
	if ((result = db->storeQuery(query.str()))) {
		page_counts = result->getDataInt("page_numeration");
	}

	if (count_row2 >= 10) {
		sendFYIBox("Voce nao pode anunciar mais produtos, limite: 10.");
		return false;
	}
	
	// Se a quantidade de produtos for equivalente a 30 e so houver 1 pagina ele define como 2 (sempre somar +1, se for 5 ï¿½ 6)
	if (total_transactions == 12 && page_counts <= 1) {
		page_counts = 2;
	}
	
	// Se a quantidade de produtos for equivalente a 30 vezes a quantidade de paginas ele cria uma nova (30*2 = 60) (30*3 = 90)
	//std::cout << "Total Atual: " << total_transactions << " - Total Que Deve Ser Atingido: " << 6 * page_counts << std::endl;
	if (total_transactions > 11 * page_counts) {
		page_counts = page_counts + 1;
	}

	query.str("");
	query << "SELECT * FROM `players_marketoffers` WHERE `ispokemon` = '" << ispokemon << "';";
	if ((result = db->storeQuery(query.str()))) {
		//
	}
	else {
		page_counts = 1;
	}

	std::list<Item*> item_list;
	for(ContainerIterator it = container->begin(), end = container->end(); it != end; ++it)
	{
		const int32_t* v = (*it)->getIntegerAttribute("itemSELECTED");
		if (v) {
			if (*v == integgerAttribute) {
				item_list.push_back((*it));
			}
		}
	}

	for(std::list<Item*>::iterator it = item_list.begin(); it != item_list.end(); ++it) {
		if (Item* item = *it) {
			PropWriteStream propWriteStream;
			item->serializeAttr(propWriteStream);

			uint32_t attributesSize = 0;
			const char* attributes = propWriteStream.getStream(attributesSize);
			
			int64_t tempo = time(NULL) + 93600;
			uint64_t random_transactionID = random_range(getGUID(), getGUID() + 30000) * random_range(1, 20);
			
			std::ostringstream description;
			if (!item->getSpecialDescription().empty()) {
				description << item->getSpecialDescription();
			}
			else {
				const ItemType& it = Item::items[item->getID()];
				description << it.description;
			}

			query.str("");
			query << "INSERT INTO `players_mymarketoffers` (`player_id`, `item_id`, `item_name`, `item_time`, `amount`, `price`, `gender`, `level`, `ispokemon`, `attributes`, `description`, `id`, `transaction_id`, `onlyoffers`) VALUES (" 
			<< getGUID() << ", " << item->getID() << ", " << db->escapeString(name) << ", " << tempo << ", " << amount << ", " << price << ", " << 0 << ", " << 0 << ", " << db->escapeString(ispokemon) << ", " << db->escapeBlob(attributes, attributesSize) << ", " << db->escapeString(description.str()) << ", " << count_row << ", " << random_transactionID << ", " << onlyoffers << ")";
			if(!db->executeQuery(query.str())) {
				return false;
			}

			query.str("");
			query << "INSERT INTO `players_marketoffers` (`player_id`, `item_id`, `item_name`, `item_seller`, `amount`, `price`, `gender`, `level`, `ispokemon`, `attributes`, `description`, `id`, `item_time`, `transaction_id`, `onlyoffers`, `page_numeration`) VALUES (" 
			<< getGUID() << ", " << item->getID() << ", " << db->escapeString(name) << ", " << db->escapeString(getName()) << ", " << amount << ", " << price << ", " << 0 << ", " << 0 << ", " << db->escapeString(ispokemon) << ", " << db->escapeBlob(attributes, attributesSize) << ", " << db->escapeString(description.str()) << ", " << count_row2 << ", " << tempo << ", " << random_transactionID << ", " << onlyoffers << "," << page_counts << ")";
			if(!db->executeQuery(query.str())) {
				return false;
			}

			ReturnValue ret = g_game.internalRemoveItem(NULL, item, amount, false, FLAG_NOLIMIT);
			if (ret != RET_NOERROR) {
				return false;
			}

			g_game.removeMoney(this, newPrice);
		}
	}

	return true;
}

bool Player::cancelMarketOffer(uint64_t numeration)
{
	Database* db = Database::getInstance();
	std::ostringstream query;
	DBResult* result = NULL;
	
	// Falta a parte de offer aqui (devolver offers para os players), comentando para nao esquecer de fazer na proxima atualizacao //

	query.str("");
	query << "SELECT `id` FROM `players_marketoffers` WHERE `player_id` = " << getGUID() << " AND `transaction_id` = " << numeration << ";";
	if ((result = db->storeQuery(query.str())))
	{
		query.str("");
		query << "DELETE FROM `players_marketoffers` WHERE `player_id` = " << getGUID() << " AND `transaction_id` = " << numeration << ";";
		if(!db->executeQuery(query.str()))
			return false;
	}

	query.str("");
	query << "SELECT `id`, `item_id`, `amount`, `attributes` FROM `players_mymarketoffers` WHERE `player_id` = " << getGUID() << " AND `transaction_id` = " << numeration << ";";
	if ((result = db->storeQuery(query.str())))
	{
		uint16_t item_id = result->getDataInt("item_id");
		uint16_t amount = result->getDataInt("amount");

        uint64_t attrSize = 0;
		const char* attr = result->getDataStream("attributes", attrSize);

		PropStream propStream;
		propStream.init(attr, attrSize);
		if(Item* item = Item::CreateItem(item_id, amount))
		{
			if(!item->unserializeAttr(propStream))
				std::cout << "[Warning - IOLoginData::loadItems] Unserialize error for item with id " << item->getID() << std::endl;
	    	
			item->setSubType(amount);
			const int32_t* v = item->getIntegerAttribute("itemSELECTED");
			if (v) {
				item->eraseAttribute("itemSELECTED");
			}

			item->setSubType(amount);
			ReturnValue ret = g_game.internalMoveItem(NULL, item->getParent(), this, INDEX_WHEREEVER, item, item->getItemCount(), 0);
			if (ret != RET_NOERROR) {
                return false;
			}

			query.str("");
			query << "DELETE FROM `players_mymarketoffers` WHERE `player_id` = " << getGUID() << " AND `transaction_id` = " << numeration << ";";
			if(!db->executeQuery(query.str()))
				return false;

			query.str("");
			query << "DELETE FROM `players_mymarketmakeoffforyour` WHERE `transaction_id` = " << numeration << ";";
			if(!db->executeQuery(query.str()))
				return false;

			query.str("");
			query << "DELETE FROM `players_mymarketmakeofftome` WHERE `transaction_id` = " << numeration << ";";
			if(!db->executeQuery(query.str()))
				return false;
		}
	}

    openMarketSellerInsertMyOffers("update");
	openMarketOfferYourOffers();
	openMarketViewOffersToYou();
	return true;
}

bool Player::openMarketSellerInsertMyOffers(std::string type)
{
	Database* db = Database::getInstance();
    DBResult* result = NULL;
    std::ostringstream query;

	uint16_t row_count = 0;

	query.str("");
	query << "SELECT `item_id`, `item_name`, `item_time`, `amount`, `price`, `gender`, `level`, `ispokemon`, `attributes`, `description`, `id`, `transaction_id`, `onlyoffers` FROM `players_mymarketoffers` WHERE `player_id` = " << getGUID() << ";";
	if ((result = db->storeQuery(query.str()))) {
		do {
			uint16_t item_id = result->getDataInt("item_id");
			uint64_t item_time = result->getDataInt("item_time");
			uint16_t amount = result->getDataInt("amount");
			uint64_t price = result->getDataInt("price");
			uint16_t gender = result->getDataInt("gender");
			uint16_t level = result->getDataInt("level");

			std::string item_name = result->getDataString("item_name");
			std::string ispokemon = result->getDataString("ispokemon");

			uint64_t attrSize = 0;
			const char* attr = result->getDataStream("attributes", attrSize);
			std::string attributes = db->escapeBlob(attr, attrSize).c_str();
			std::string description = result->getDataString("description");

			uint16_t row_count_id = result->getDataInt("id");
			row_count = row_count + 1;

			uint64_t transaction_id = result->getDataInt("transaction_id");
			bool onlyoffers = result->getDataInt("onlyoffers");

			CreatureEventList events = getCreatureEvents(CREATURE_EVENT_INSERT_MARKET_MYOFFERS);
			for(CreatureEventList::iterator it = events.begin(); it != events.end(); ++it) {
				(*it)->executeInsertMarketMyOffers(this, item_id, item_name, item_time, amount, price, gender, level, ispokemon, attributes, description, row_count, row_count_id, type, transaction_id, onlyoffers);
			}

        } while(result->next());
        
		result->free();
	}

	return true;
}

bool Player::openMarketBuyInsertAllOffers()
{
	Database* db = Database::getInstance();
    DBResult* result = NULL;
    std::ostringstream query;
	
	uint16_t page_counts = 0;
	query.str("");
	query << "SELECT `page_numeration` FROM `players_marketoffers` ORDER BY page_numeration DESC LIMIT 1;";
	if ((result = db->storeQuery(query.str()))) {
		page_counts = result->getDataInt("page_numeration");
	}

	uint16_t row_count = 0;
	query.str("");
	query << "SELECT `item_id`, `item_name`, `item_seller`, `amount`, `price`, `gender`, `level`, `ispokemon`, `attributes`, `description`, `id`, `item_time`, `transaction_id`, `onlyoffers` FROM `players_marketoffers` WHERE `page_numeration` = '1'";
	if ((result = db->storeQuery(query.str()))) {
		do {
			uint16_t item_id = result->getDataInt("item_id");
			uint16_t amount = result->getDataInt("amount");
			uint64_t price = result->getDataInt("price");
			uint16_t gender = result->getDataInt("gender");
			uint16_t level = result->getDataInt("level");

			std::string item_seller = result->getDataString("item_seller");
			std::string item_name = result->getDataString("item_name");
			std::string ispokemon = result->getDataString("ispokemon");

			uint64_t attrSize = 0;
			const char* attr = result->getDataStream("attributes", attrSize);
			std::string attributes = db->escapeBlob(attr, attrSize).c_str();
			std::string description = result->getDataString("description");

			uint16_t row_count_id = result->getDataInt("id");
			uint64_t item_time = result->getDataInt("item_time");
			row_count = row_count + 1;

			uint64_t transaction_id = result->getDataInt("transaction_id");
			bool onlyoffers = result->getDataInt("onlyoffers");

			CreatureEventList events = getCreatureEvents(CREATURE_EVENT_INSERT_MARKET_ALLOFFERS);
			for(CreatureEventList::iterator it = events.begin(); it != events.end(); ++it) {
				(*it)->executeInsertMarketAllOffers(this, item_id, item_name, item_seller, amount, price, gender, level, ispokemon, attributes, description, row_count, row_count_id, item_time, transaction_id, onlyoffers, page_counts);
			}

        } while(result->next());
        
		result->free();
	}

	return true;
}

bool Player::buyMarketItemOffer(uint64_t price, uint64_t transaction_id, uint64_t countSelectedScrollBar)
{
	if (g_game.getMoney(this) < price * countSelectedScrollBar) { // * 100 *
		sendFYIBox("Voce nao possui dinheiro suficiente para comprar este produto.");
		return false;
	}

	Database* db = Database::getInstance();
	std::ostringstream query;
	DBResult* result = NULL;
	
	query.str("");
	query << "SELECT `transaction_id`, `item_id`, `item_name`, `amount`, `attributes`, `player_id`, `item_seller`, `ispokemon` FROM `players_marketoffers` WHERE `transaction_id` = " << transaction_id << ";";
	if ((result = db->storeQuery(query.str())))
	{
		//uint32_t player_id = result->getDataInt("player_id");
		uint16_t item_id = result->getDataInt("item_id");
		uint16_t amount = result->getDataInt("amount");
		std::string item_name = result->getDataString("item_name");
		std::string item_seller = result->getDataString("item_seller");
		std::string ispokemon = result->getDataString("ispokemon");

		/* if (result->getDataInt("player_id") == getGUID()) {
			sendFYIBox("Voce nao pode comprar um produto que voce mesmo anunciou.");
			return false;
		} */

		uint64_t attrSize = 0;
		const char* attr = result->getDataStream("attributes", attrSize);
		
		if ((int)countSelectedScrollBar > result->getDataInt("amount")) {
			sendFYIBox("Voce nao pode comprar mais do que tem de oferta.");
			return false;
		}

		PropStream propStream;
		propStream.init(attr, attrSize);

		if(Item* item = Item::CreateItem(item_id, countSelectedScrollBar))
		{
			if(!item->unserializeAttr(propStream))
				std::cout << "[Warning - IOLoginData::loadItems] Unserialize error for item with id " << item->getID() << std::endl;
	    	
			const int32_t* v = item->getIntegerAttribute("itemSELECTED");
			if (v) {
				item->eraseAttribute("itemSELECTED");
			}

			item->setSubType(countSelectedScrollBar);
			
			if (getFreeCapacity() <= 0) {
				sendTextMessage(MSG_EVENT_ADVANCE, "Quantidade de capacidade insuficiente para receber o produto.");
				return false;
			}
			
			uint8_t totalBalls = 0;
			Item* item_bp = getInventoryItem((slots_t)3);
			if (!item_bp) {
				return false;
			}
			
			Container* pokemonBackpack = item_bp->getContainer();
			if (!pokemonBackpack) {
				return false;
			}
			
			for(ContainerIterator it = pokemonBackpack->begin(); it != pokemonBackpack->end(); ++it){
                const std::string* pokemon = (*it)->getStringAttribute("poke");
                if (pokemon) {
                     totalBalls += 1;
                }
			}
			
			Item* item_feet = getInventoryItem((slots_t)8);
			if (item_feet) {
				totalBalls = totalBalls + 1;
			}
			
			if (totalBalls >= 6 && ispokemon == "isPokemon") {
				sendTextMessage(MSG_EVENT_ADVANCE, "Quantidade de pokemons muito alta para receber o produto.");
				return false;
			}
			
			Player* player = g_game.getPlayerByNameEx(item_seller);
    			if (player) {
				if (player->getFreeCapacity() <= 0) {
					sendTextMessage(MSG_EVENT_ADVANCE, "Jogador que vende o produto está com a capacidade insuficiente para receber o dinheiro.");
					return false;
				}
			
				/* ReturnValue ret = g_game.internalAddItem(NULL, player->getDepot(player->getLastDepotId(), true), item2, INDEX_WHEREEVER, FLAG_NOLIMIT);
				if (ret != RET_NOERROR) {
					return false;
				} */

				g_game.addMoney(player, price * countSelectedScrollBar); // * 100 *
				IOLoginData::getInstance()->savePlayer(player);
			}

			g_game.removeMoney(this, price * countSelectedScrollBar);
			
			Depot* depot = getDepot(getTown(), true);
			Cylinder* receiveContainer = NULL;
			if (!depot) {
				receiveContainer = this;
			}

			if (receiveContainer) {
				ReturnValue ret = g_game.internalMoveItem(NULL, item->getParent(), receiveContainer, INDEX_WHEREEVER, item, countSelectedScrollBar, 0);
				if (ret != RET_NOERROR) {
					return false;
				}
			}
			else {
				ReturnValue ret = g_game.internalMoveItem(NULL, item->getParent(), depot, INDEX_WHEREEVER, item, countSelectedScrollBar, 0);
				if (ret != RET_NOERROR) {
					return false;
				}
			}
		}

		if (amount == 1 || amount == countSelectedScrollBar) {
			query.str("");
			query << "DELETE FROM `players_marketoffers` WHERE `transaction_id` = " << transaction_id << ";";
			if(!db->executeQuery(query.str()))
				return false; 

			query.str("");
			query << "DELETE FROM `players_mymarketoffers` WHERE `transaction_id` = " << transaction_id << ";";
			if(!db->executeQuery(query.str()))
				return false;

			query.str("");
			query << "DELETE FROM `players_mymarketmakeoffforyour` WHERE `transaction_id` = " << transaction_id << ";";
			if(!db->executeQuery(query.str()))
				return false;

			query.str("");
			query << "DELETE FROM `players_mymarketmakeofftome` WHERE `transaction_id` = " << transaction_id << ";";
			if(!db->executeQuery(query.str()))
				return false;

			query.str("");
			query << "INSERT INTO `players_mymarketpurchases` (`player_id`, `item_name`, `amount`, `date`) VALUES (" 
			<< getGUID() << ", " << db->escapeString(item_name) << ", " << amount << ", " << time(NULL) << ")";
			if(!db->executeQuery(query.str())) {
				return false;
			}
			
			Player* player = g_game.getPlayerByNameEx(item_seller);
    		if (player) {
				/* ReturnValue ret = g_game.internalAddItem(NULL, player->getDepot(player->getLastDepotId(), true), item2, INDEX_WHEREEVER, FLAG_NOLIMIT);
				if (ret != RET_NOERROR) {
					return false;
				} */

				CreatureEventList events = player->getCreatureEvents(CREATURE_EVENT_INSERT_MARKETBUYOFFER_UPDATE);
				for(CreatureEventList::iterator it = events.begin(); it != events.end(); ++it) {
					(*it)->executeBuyOfferUpdateMarketWindow(this);
				}
				
				player->openMarketSellerInsertMyOffers("update");
				player->openMarketOfferYourOffers();
				player->openMarketViewOffersToYou();
				
				CreatureEventList events2 = getCreatureEvents(CREATURE_EVENT_INSERT_MARKETBUYOFFER_UPDATE);
				for(CreatureEventList::iterator it = events2.begin(); it != events2.end(); ++it) {
					(*it)->executeBuyOfferUpdateMarketWindow(this);
				}
				
				openMarketSellerInsertMyOffers("update");
				openMarketOfferYourOffers();
				openMarketViewOffersToYou();
			}
		}
		else {
			query.str("");
			query << "SELECT `transaction_id`, `item_id`, `item_name`, `amount`, `attributes`, `player_id`, `item_seller` FROM `players_marketoffers` WHERE `transaction_id` = " << transaction_id << ";";
			if ((result = db->storeQuery(query.str())))
			{
				uint16_t amount = result->getDataInt("amount") - countSelectedScrollBar;
				query.str("");
				query << "UPDATE `players_marketoffers` SET `amount` = " << amount << " WHERE `transaction_id` = " << transaction_id << db->getUpdateLimiter();
				if(!db->executeQuery(query.str()))
					return false;

				query.str("");
				query << "UPDATE `players_mymarketoffers` SET `amount` = " << amount << " WHERE `transaction_id` = " << transaction_id << db->getUpdateLimiter();
				if(!db->executeQuery(query.str()))
					return false;

				query.str("");
				query << "UPDATE `players_mymarketmakeoffforyour` SET `amount` = " << amount << " WHERE `transaction_id` = " << transaction_id << db->getUpdateLimiter();
				if(!db->executeQuery(query.str()))
					return false;

				query.str("");
				query << "UPDATE `players_mymarketmakeofftome` SET `amount` = " << amount << " WHERE `transaction_id` = " << transaction_id << db->getUpdateLimiter();
				if(!db->executeQuery(query.str()))
					return false;
				
				query.str("");
				query << "INSERT INTO `players_mymarketpurchases` (`player_id`, `item_name`, `amount`, `date`) VALUES (" 
				<< getGUID() << ", " << db->escapeString(item_name) << ", " << countSelectedScrollBar << ", " << time(NULL) << ")";
				if(!db->executeQuery(query.str())) {
					return false;
				}
			}
		}
	}			
	else {
		sendFYIBox("A oferta que esteja tentando comprar nao esteja mais disponivel.");
		return false;
	}
	return true;
}

bool Player::openMarketInsertAllHistoric()
{
	Database* db = Database::getInstance();
    DBResult* result = NULL;
    std::ostringstream query;

	//uint16_t row_count = 0;
	query.str("");
	query << "SELECT `player_id`, `item_name`, `amount`, `date` FROM `players_mymarketpurchases` WHERE `player_id` = " << getGUID() << ";";
	if ((result = db->storeQuery(query.str()))) {
		do {
			std::string item_name = result->getDataString("item_name");

			uint32_t amount = result->getDataInt("amount");
			uint64_t date = result->getDataInt("date");

			CreatureEventList events = getCreatureEvents(CREATURE_EVENT_INSERT_MARKET_MYHISTORIC);
			for(CreatureEventList::iterator it = events.begin(); it != events.end(); ++it) {
				(*it)->executeInsertMarketHistoric(this, item_name, amount, date);
			}
		} while(result->next());
        
		result->free();
	}

	return true;
}

bool Player::makeMarketOfferRemoveItem(uint16_t index, uint64_t transaction_id)
{
	std::string storage;
	if (getStorage(transaction_id, storage) && storage == "offerted") {
		sendFYIBox("Voce ja realizou uma oferta para este item.");
		return false;
	}

	Item* backpack = getInventoryItem((slots_t)SLOT_BACKPACK);
	if (!backpack) {
		return false;
	}

	Container* container = backpack->getContainer();
	if (!container) {
		return false;
	}

	if (Item* item = container->getItem(index)) {
		ReturnValue ret = g_game.internalRemoveItem(NULL, item, item->getSubType(), false, FLAG_NOLIMIT);
		if (ret != RET_NOERROR) {
			return false;
		}

		Item* newItem = Item::CreateItem(item->getID(), item->getSubType());
		if(!newItem)
			return false;

		newItem->copyAttributes(item);
		waiting_list.push_back(newItem);

		CreatureEventList events = getCreatureEvents(CREATURE_EVENT_INSERT_MARKET_MAKEOFFREMOVEITEM);
		for(CreatureEventList::iterator it = events.begin(); it != events.end(); ++it) {
			(*it)->executeMarketOfferRemoveItem(this, newItem->getID(), newItem->getSpecialDescription(), newItem->getItemCount());
		}
	}

	return true;
}

bool Player::confirmMarketOfferToPlayer(uint64_t transaction_id, std::string item_seller, uint16_t index) // Index is not in using!!
{
	if (waiting_list.size() <= 0)
	{
		sendFYIBox("Voce deve colocar pelo menos um item para poder ofertar.");
		return false;
	}

	Database* db = Database::getInstance();
	std::ostringstream query;
	DBResult* result = NULL;
	uint64_t player_id2 = 0;
	uint16_t count_row = 0;

	query.str("");
	query << "SELECT `player_id` FROM `players_marketoffers` WHERE `transaction_id` = " << transaction_id << ";";
	if ((result = db->storeQuery(query.str())))
	{
		/* if (result->getDataInt("player_id") == getGUID()) {
			sendFYIBox("Voce nao pode ofertar para um produto que voce mesmo anunciou.");
			return false;
		} */

		player_id2 = result->getDataInt("player_id");
	}
	else {
		sendFYIBox("Este item nao esta mais disponivel para oferta, atualize a pagina.");
		return true;
	}

	query.str("");
	query << "SELECT COUNT(*) FROM `players_mymarketmakeoffforyour` WHERE `player_id1` = " << getGUID() << ";";
	if ((result = db->storeQuery(query.str()))) {
		count_row = result->getDataInt("COUNT(*)") + 1;
	}

    for(std::vector<Item*>::iterator it = waiting_list.begin(); it != waiting_list.end(); ++it) {
		if (Item* item = *it) {
			//std::cout << item->getID() << std::endl;
			query.str("");
			query << "SELECT `item_id`, `item_name`, `description` FROM `players_marketoffers` WHERE `transaction_id` = " << transaction_id << ";";
			if ((result = db->storeQuery(query.str()))) {
				uint16_t item_id = result->getDataInt("item_id");
				std::string item_name = result->getDataString("item_name");
				std::string description = result->getDataString("description");

				query.str("");
				query << "INSERT INTO `players_mymarketmakeoffforyour` (`player_id1`, `player_id2`, `item_id1`, `item_id2`, `item_name1`, `item_name2`, `description1`, `description2`, `attributes`, `item_seller`, `transaction_id`, `amount`) VALUES (" 
				<< getGUID() << ", " << player_id2 << ", " << item_id << ", " << item->getID() << ", " << db->escapeString(item_name) << ", " << db->escapeString(item->getName()) << ", " << db->escapeString(description) << ", " << db->escapeString(item->getSpecialDescription()) << ", " << db->escapeBlob("", 0).c_str() << ", " << db->escapeString(item_seller) << ", " << transaction_id << ", " << item->getSubType() << ")";
				if(!db->executeQuery(query.str())) {
					return false;
				}

				query.str("");
				query << "INSERT INTO `players_mymarketmakeofftome` (`player_id1`, `player_id2`, `item_id1`, `item_id2`, `item_name1`, `item_name2`, `description1`, `description2`, `attributes`, `item_seller`, `transaction_id`, `amount`) VALUES (" 
				<< player_id2 << ", " << getGUID() << ", " << item->getID() << ", " << item_id << ", " << db->escapeString(item->getName()) << ", " << db->escapeString(item_name) << ", " << db->escapeString(item->getSpecialDescription()) << ", " << db->escapeString(description) << ", " << db->escapeBlob("", 0).c_str() << ", " << db->escapeString(getName()) << ", " << transaction_id << ", " << item->getSubType() << ")";
				if(!db->executeQuery(query.str())) {
					return false;
				}

				CreatureEventList events = getCreatureEvents(CREATURE_EVENT_INSERT_MARKET_UPDATEOFFERS);
				for(CreatureEventList::iterator it = events.begin(); it != events.end(); ++it) {
					(*it)->executeMakeOffers(this, item_id, item_name, item_seller, count_row, description, transaction_id);
				}
			}
		}
	}

	for(uint32_t i = 0; i < waiting_list.size(); i++) {
		if (waiting_list[i]) {
			waiting_list[i] = NULL;
		}
	}

	sendFYIBox("Sua oferta foi realizada com sucesso, o vendedor sera notificado sobre sua oferta.");
	setStorage(transaction_id, "offerted");
	return true;
}

bool Player::openMarketOfferYourOffers()
{
	Database* db = Database::getInstance();
	std::ostringstream query;
	DBResult* result = NULL;

	uint16_t count_row = 0;
	query.str("");
	query << "SELECT `item_id1`, `item_name1`, `description1`, `item_seller`, `transaction_id` FROM `players_mymarketmakeoffforyour` WHERE `player_id1` = " << getGUID() << ";";
	if ((result = db->storeQuery(query.str()))) {
		do {
			uint16_t item_id = result->getDataInt("item_id1");
			std::string item_name = result->getDataString("item_name1");
			std::string description = result->getDataString("description1");
			std::string item_seller = result->getDataString("item_seller");
			uint64_t transaction_id = result->getDataInt("transaction_id");
			count_row = count_row + 1;

			CreatureEventList events = getCreatureEvents(CREATURE_EVENT_INSERT_MARKET_UPDATEOFFERS);
			for(CreatureEventList::iterator it = events.begin(); it != events.end(); ++it) {
				(*it)->executeMakeOffers(this, item_id, item_name, item_seller, count_row, description, transaction_id);
			}
        } while(result->next());
        
		result->free();
	}

	return true;
}

bool Player::openMarketInsertMyOffersInAllSlots(uint64_t transaction_id)
{
	Database* db = Database::getInstance();
	std::ostringstream query;
	DBResult* result = NULL;

	query.str("");
	query << "SELECT `item_id2`, `description2`, `amount` FROM `players_mymarketmakeoffforyour` WHERE `transaction_id` = " << transaction_id << ";";
	if ((result = db->storeQuery(query.str()))) {
		do {
			uint16_t item_id = result->getDataInt("item_id2");
			uint16_t amount = result->getDataInt("amount");
			std::string description = result->getDataString("description2");

			CreatureEventList events = getCreatureEvents(CREATURE_EVENT_INSERT_MARKET_MAKEOFFREMOVEITEM);
			for(CreatureEventList::iterator it = events.begin(); it != events.end(); ++it) {
				(*it)->executeMarketOfferRemoveItem(this, item_id, description, amount);
			}
		} while(result->next());
        
		result->free();
	}

	return true;
}

bool Player::openMarketInsertOffersToMeInAllSlots(uint64_t transaction_id)
{
	Database* db = Database::getInstance();
	std::ostringstream query;
	DBResult* result = NULL;

	query.str("");
	query << "SELECT `item_id1`, `description1`, `amount` FROM `players_mymarketmakeofftome` WHERE `transaction_id` = " << transaction_id << ";";
	if ((result = db->storeQuery(query.str()))) {
		do {
			uint16_t item_id = result->getDataInt("item_id1");
			uint16_t amount = result->getDataInt("amount");
			std::string description = result->getDataString("description1");

			CreatureEventList events = getCreatureEvents(CREATURE_EVENT_INSERT_MARKET_MAKEOFFREMOVEITEM);
			for(CreatureEventList::iterator it = events.begin(); it != events.end(); ++it) {
				(*it)->executeMarketOfferRemoveItem(this, item_id, description, amount);
			}
		} while(result->next());
        
		result->free();
	}

	return true;
}

bool Player::sendMarketCancelYourOfferBackBuyer(uint64_t transaction_id)
{
	Database* db = Database::getInstance();
	std::ostringstream query;
	DBResult* result = NULL;

	query.str("");
	query << "SELECT `transaction_id`, `item_id2`, `amount`, `description1`, `attributes`, `player_id1` FROM `players_mymarketmakeoffforyour` WHERE `transaction_id` = " << transaction_id << ";";
	if ((result = db->storeQuery(query.str())))
	{
		do {
			uint16_t player_id = result->getDataInt("player_id1");
			uint16_t item_id = result->getDataInt("item_id2");
			uint16_t amount = result->getDataInt("amount");

			uint64_t attrSize = 0;
			const char* attr = result->getDataStream("attributes", attrSize);

			PropStream propStream;
			propStream.init(attr, attrSize);
			if(Item* item = Item::CreateItem(item_id, amount))
			{
				if(!item->unserializeAttr(propStream))
					std::cout << "[Warning - IOLoginData::loadItems] Unserialize error for item with id " << item->getID() << std::endl;

				query.str("");
				query << "SELECT `name` FROM `players` WHERE `id` = " << player_id << " AND `deleted` = 0";
				
				if(!(result = db->storeQuery(query.str())))
					return false;
				
				Player* player = g_game.getPlayerByNameEx(result->getDataString("name"));
				if (player) {
					ReturnValue ret = g_game.internalMoveItem(NULL, item->getParent(), player, INDEX_WHEREEVER, item, item->getItemCount(), 0);
					if (ret != RET_NOERROR) {
						return false;
					}
				}
			}
		} while(result->next());
		result->free();			

		query.str("");
		query << "DELETE FROM `players_mymarketmakeoffforyour` WHERE `transaction_id` = " << transaction_id << ";";
		if(!db->executeQuery(query.str()))
			return false;

		query.str("");
		query << "DELETE FROM `players_mymarketmakeofftome` WHERE `transaction_id` = " << transaction_id << ";";
		if(!db->executeQuery(query.str()))
			return false;
	}

	setStorage(transaction_id, "none");
	openMarketOfferYourOffers();
	return true;
}

bool Player::openMarketViewOffersToYou()
{
	Database* db = Database::getInstance();
	std::ostringstream query;
	DBResult* result = NULL;

	uint16_t row_count = 0;
	query.str("");
	query << "SELECT `item_name2`, `item_id2`, `description2`, `transaction_id` FROM `players_mymarketmakeofftome` WHERE `player_id1` = " << getGUID() << ";";
	if ((result = db->storeQuery(query.str()))) {
		do {
			std::string item_name = result->getDataString("item_name2");
			std::string description = result->getDataString("description2");
			uint16_t item_id = result->getDataInt("item_id2");
			uint64_t transaction_id = result->getDataInt("transaction_id");
			row_count = row_count + 1;

			CreatureEventList events = getCreatureEvents(CREATURE_EVENT_INSERT_MARKET_OFFERSTOME);
			for(CreatureEventList::iterator it = events.begin(); it != events.end(); ++it) {
				uint64_t tempo = time(NULL) + 93600;
				(*it)->executeMarketViewOffersToMe(this, item_id, item_name, description, tempo, row_count, transaction_id);
			}
		} while(result->next());
		result->free();
	}

	return true;
}

bool Player::confirmMarketOfferToMe(uint64_t transaction_id)
{
	Database* db = Database::getInstance();
	std::ostringstream query;
	DBResult* result = NULL;

	uint16_t item_id1 = 0;
	std::string item_seller = "";

	query.str("");
	query << "SELECT `item_id2`, `description2`, `attributes`, `amount` FROM `players_mymarketmakeoffforyour` WHERE `transaction_id` = " << transaction_id << ";";
	if ((result = db->storeQuery(query.str()))) {
		do {
			uint16_t item_id = result->getDataInt("item_id2");
			uint16_t amount = result->getDataInt("amount");

			uint64_t attrSize = 0;
			const char* attr = result->getDataStream("attributes", attrSize);

			PropStream propStream;
			propStream.init(attr, attrSize);
			if(Item* item = Item::CreateItem(item_id, amount))
			{
				if(!item->unserializeAttr(propStream))
					std::cout << "[Warning - IOLoginData::loadItems] Unserialize error for item with id " << item->getID() << std::endl;

				ReturnValue ret = g_game.internalMoveItem(NULL, item->getParent(), this, INDEX_WHEREEVER, item, amount, 0);
				if (ret != RET_NOERROR) {
					return false;
				}
			}
		} while(result->next());
			result->free();
		}

		query.str("");
		query << "SELECT `item_id2`, `amount`, `amount`, `item_seller` FROM `players_mymarketmakeofftome` WHERE `transaction_id` = " << transaction_id << ";";
		if ((result = db->storeQuery(query.str()))) {
			item_id1 = result->getDataInt("item_id2");
			item_seller = result->getDataString("item_seller");
		}

		query.str("");
		query << "SELECT `attributes`, `amount` FROM `players_mymarketoffers` WHERE `transaction_id` = " << transaction_id << ";";
		if ((result = db->storeQuery(query.str()))) {
			uint16_t amount1 = result->getDataInt("amount");
			uint64_t attrSize = 0;
			const char* attr = result->getDataStream("attributes", attrSize);

			PropStream propStream;
			propStream.init(attr, attrSize);
			if(Item* item = Item::CreateItem(item_id1, amount1))
			{
				if(!item->unserializeAttr(propStream))
					std::cout << "[Warning - IOLoginData::loadItems] Unserialize error for item with id " << item->getID() << std::endl;

				Player* player = g_game.getPlayerByNameEx(item_seller);
				if (player) {
					ReturnValue ret = g_game.internalMoveItem(NULL, item->getParent(), player, INDEX_WHEREEVER, item, item->getItemCount(), 0);
					if (ret != RET_NOERROR) {
						return false;
				    }

					IOLoginData::getInstance()->savePlayer(player);
				}

				query.str("");
				query << "DELETE FROM `players_mymarketmakeoffforyour` WHERE `transaction_id` = " << transaction_id << ";";
				if(!db->executeQuery(query.str()))
					return false;

				query.str("");
				query << "DELETE FROM `players_mymarketmakeofftome` WHERE `transaction_id` = " << transaction_id << ";";
				if(!db->executeQuery(query.str()))
					return false;

				query.str("");
				query << "DELETE FROM `players_marketoffers` WHERE `transaction_id` = " << transaction_id << ";";
				if(!db->executeQuery(query.str()))
					return false;

				query.str("");
				query << "DELETE FROM `players_mymarketoffers` WHERE `transaction_id` = " << transaction_id << ";";
				if(!db->executeQuery(query.str()))
					return false;
			}
	}

	CreatureEventList events = getCreatureEvents(CREATURE_EVENT_INSERT_MARKETBUYOFFER_UPDATE);
	for(CreatureEventList::iterator it = events.begin(); it != events.end(); ++it) {
		(*it)->executeBuyOfferUpdateMarketWindow(this);
	}

	openMarketViewOffersToYou();
	return true;
}

bool Player::reedemMyItemsOfferInList()
{
	for(std::vector<Item*>::iterator it = waiting_list.begin(); it != waiting_list.end(); ++it) {
		if (Item* item = *it) {
			Depot* depot = getDepot(1, true);
			if (!depot)
				return false;

			ReturnValue ret = g_game.internalMoveItem(NULL, item->getParent(), depot, INDEX_WHEREEVER, item, item->getItemCount(), 0);
			if (ret != RET_NOERROR) {
				return false;
			}
		}
	}

	return true;
}

bool Player::sendMarketChangeOption(std::string option)
{
	Database* db = Database::getInstance();
    DBResult* result = NULL;
    std::ostringstream query;

	uint16_t row_count = 0;
	uint16_t page_counts = 0;
	query.str("");
	query << "SELECT `page_numeration` FROM `players_marketoffers` ORDER BY page_numeration DESC LIMIT 1;";
	if ((result = db->storeQuery(query.str()))) {
		page_counts = result->getDataInt("page_numeration");
	}
	
	query.str("");
	query << "SELECT `item_id`, `item_name`, `item_seller`, `amount`, `price`, `gender`, `level`, `ispokemon`, `attributes`, `description`, `id`, `item_time`, `transaction_id`, `onlyoffers` FROM `players_marketoffers`";
	if ((result = db->storeQuery(query.str()))) {
		do {
			if (option == "Pokemons" && result->getDataString("ispokemon") == "isPokemon") {
				uint16_t item_id = result->getDataInt("item_id");
				uint16_t amount = result->getDataInt("amount");
				uint64_t price = result->getDataInt("price");
				uint16_t gender = result->getDataInt("gender");
				uint16_t level = result->getDataInt("level");

				std::string item_seller = result->getDataString("item_seller");
				std::string item_name = result->getDataString("item_name");
				std::string ispokemon = result->getDataString("ispokemon");

				uint64_t attrSize = 0;
				const char* attr = result->getDataStream("attributes", attrSize);
				std::string attributes = db->escapeBlob(attr, attrSize).c_str();
				std::string description = result->getDataString("description");

				uint16_t row_count_id = result->getDataInt("id");
				uint64_t item_time = result->getDataInt("item_time");
				row_count = row_count + 1;

				uint64_t transaction_id = result->getDataInt("transaction_id");
				bool onlyoffers = result->getDataInt("onlyoffers");

				CreatureEventList events = getCreatureEvents(CREATURE_EVENT_INSERT_MARKET_ALLOFFERS);
				for(CreatureEventList::iterator it = events.begin(); it != events.end(); ++it) {
					(*it)->executeInsertMarketAllOffers(this, item_id, item_name, item_seller, amount, price, gender, level, ispokemon, attributes, description, row_count, row_count_id, item_time, transaction_id, onlyoffers, page_counts);
				}
			}

			if (option == "Decoracoes" && result->getDataString("ispokemon") == "Decoracoes") {
				uint16_t item_id = result->getDataInt("item_id");
				uint16_t amount = result->getDataInt("amount");
				uint64_t price = result->getDataInt("price");
				uint16_t gender = result->getDataInt("gender");
				uint16_t level = result->getDataInt("level");

				std::string item_seller = result->getDataString("item_seller");
				std::string item_name = result->getDataString("item_name");
				std::string ispokemon = result->getDataString("ispokemon");

				uint64_t attrSize = 0;
				const char* attr = result->getDataStream("attributes", attrSize);
				std::string attributes = db->escapeBlob(attr, attrSize).c_str();
				std::string description = result->getDataString("description");

				uint16_t row_count_id = result->getDataInt("id");
				uint64_t item_time = result->getDataInt("item_time");
				row_count = row_count + 1;

				uint64_t transaction_id = result->getDataInt("transaction_id");
				bool onlyoffers = result->getDataInt("onlyoffers");

				CreatureEventList events = getCreatureEvents(CREATURE_EVENT_INSERT_MARKET_ALLOFFERS);
				for(CreatureEventList::iterator it = events.begin(); it != events.end(); ++it) {
					(*it)->executeInsertMarketAllOffers(this, item_id, item_name, item_seller, amount, price, gender, level, ispokemon, attributes, description, row_count, row_count_id, item_time, transaction_id, onlyoffers, page_counts);
				}
			}

			if (option == "Stones" && result->getDataString("ispokemon") == "Stones") {
				uint16_t item_id = result->getDataInt("item_id");
				uint16_t amount = result->getDataInt("amount");
				uint64_t price = result->getDataInt("price");
				uint16_t gender = result->getDataInt("gender");
				uint16_t level = result->getDataInt("level");

				std::string item_seller = result->getDataString("item_seller");
				std::string item_name = result->getDataString("item_name");
				std::string ispokemon = result->getDataString("ispokemon");

				uint64_t attrSize = 0;
				const char* attr = result->getDataStream("attributes", attrSize);
				std::string attributes = db->escapeBlob(attr, attrSize).c_str();
				std::string description = result->getDataString("description");

				uint16_t row_count_id = result->getDataInt("id");
				uint64_t item_time = result->getDataInt("item_time");
				row_count = row_count + 1;

				uint64_t transaction_id = result->getDataInt("transaction_id");
				bool onlyoffers = result->getDataInt("onlyoffers");

				CreatureEventList events = getCreatureEvents(CREATURE_EVENT_INSERT_MARKET_ALLOFFERS);
				for(CreatureEventList::iterator it = events.begin(); it != events.end(); ++it) {
					(*it)->executeInsertMarketAllOffers(this, item_id, item_name, item_seller, amount, price, gender, level, ispokemon, attributes, description, row_count, row_count_id, item_time, transaction_id, onlyoffers, page_counts);
				}
			}

			if (option == "All") {
				uint16_t item_id = result->getDataInt("item_id");
				uint16_t amount = result->getDataInt("amount");
				uint64_t price = result->getDataInt("price");
				uint16_t gender = result->getDataInt("gender"); 
				uint16_t level = result->getDataInt("level");

				std::string item_seller = result->getDataString("item_seller");
				std::string item_name = result->getDataString("item_name");
				std::string ispokemon = result->getDataString("ispokemon"); // 

				uint64_t attrSize = 0;
				const char* attr = result->getDataStream("attributes", attrSize);
				std::string attributes = db->escapeBlob(attr, attrSize).c_str();
				std::string description = result->getDataString("description");

				uint16_t row_count_id = result->getDataInt("id");
				uint64_t item_time = result->getDataInt("item_time");
				row_count = row_count + 1;

				uint64_t transaction_id = result->getDataInt("transaction_id");
				bool onlyoffers = result->getDataInt("onlyoffers");

				CreatureEventList events = getCreatureEvents(CREATURE_EVENT_INSERT_MARKET_ALLOFFERS);
				for(CreatureEventList::iterator it = events.begin(); it != events.end(); ++it) {
					(*it)->executeInsertMarketAllOffers(this, item_id, item_name, item_seller, amount, price, gender, level, ispokemon, attributes, description, row_count, row_count_id, item_time, transaction_id, onlyoffers, page_counts);
				}
			}
        } while(result->next());
        
		result->free();
	}

	return true;
}

bool Player::sendMarketChangePage(std::string type, std::string category, uint64_t page)
{
	Database* db = Database::getInstance();
    DBResult* result = NULL;
    std::ostringstream query;
	
	if (page <= 0) {
		page = 1;
	}

	uint64_t page_counts = 1;
	uint64_t page_numeration = 1; // determinar a pagina que o player tï¿½
	
	query.str("");
	query << "SELECT `page_numeration` FROM `players_marketoffers` ORDER BY page_numeration DESC LIMIT 1;";
	if ((result = db->storeQuery(query.str()))) {
		page_counts = result->getDataInt("page_numeration");
	}
	
	if (type == "backAllPages") {
		page_numeration = 1;
	}
	else if (type == "backOnePage" && page != 1) {
		page_numeration = page; // fiz essa alteraï¿½ï¿½o pra testar
	}
	else if (type == "backOnePage" && page == 1) {
		page_numeration = 1;
	}
	else if (type == "nextOnePage") {
		page_numeration = page; // desse jeito ele retorna aquele valor que te mandei a print no discord
	}
	else if (type == "nextAllPages") {
		page_numeration = page_counts;
	}

	uint16_t row_count = 0;
	query.str("");
	query << "SELECT `item_id`, `item_name`, `item_seller`, `amount`, `price`, `gender`, `level`, `ispokemon`, `attributes`, `description`, `id`, `item_time`, `transaction_id`, `onlyoffers`, `page_numeration` FROM `players_marketoffers` WHERE `page_numeration` = '" << page_numeration << "';";
	if ((result = db->storeQuery(query.str()))) {
		do {
			if (result->getDataString("ispokemon") == "isPokemon" && category == "Pokemons") {
				uint16_t item_id = result->getDataInt("item_id");
				uint16_t amount = result->getDataInt("amount");
				uint64_t price = result->getDataInt("price");
				uint16_t gender = result->getDataInt("gender");
				uint16_t level = result->getDataInt("level");

				std::string item_seller = result->getDataString("item_seller");
				std::string item_name = result->getDataString("item_name");
				std::string ispokemon = result->getDataString("ispokemon");

				uint64_t attrSize = 0;
				const char* attr = result->getDataStream("attributes", attrSize);
				std::string attributes = db->escapeBlob(attr, attrSize).c_str();
				std::string description = result->getDataString("description");

				uint16_t row_count_id = result->getDataInt("id");
				uint64_t item_time = result->getDataInt("item_time");
				row_count = row_count + 1;

				uint64_t transaction_id = result->getDataInt("transaction_id");
				bool onlyoffers = result->getDataInt("onlyoffers");

				CreatureEventList events = getCreatureEvents(CREATURE_EVENT_INSERT_MARKET_ALLOFFERS);
				for(CreatureEventList::iterator it = events.begin(); it != events.end(); ++it) {
					(*it)->executeInsertMarketAllOffers(this, item_id, item_name, item_seller, amount, price, gender, level, ispokemon, attributes, description, row_count, row_count_id, item_time, transaction_id, onlyoffers, page_counts);
				}
			}

			if (result->getDataString("ispokemon") == "Decoracoes" && category == "Decoracoes") {
				uint16_t item_id = result->getDataInt("item_id");
				uint16_t amount = result->getDataInt("amount");
				uint64_t price = result->getDataInt("price");
				uint16_t gender = result->getDataInt("gender");
				uint16_t level = result->getDataInt("level");

				std::string item_seller = result->getDataString("item_seller");
				std::string item_name = result->getDataString("item_name");
				std::string ispokemon = result->getDataString("ispokemon");

				uint64_t attrSize = 0;
				const char* attr = result->getDataStream("attributes", attrSize);
				std::string attributes = db->escapeBlob(attr, attrSize).c_str();
				std::string description = result->getDataString("description");

				uint16_t row_count_id = result->getDataInt("id");
				uint64_t item_time = result->getDataInt("item_time");
				row_count = row_count + 1;

				uint64_t transaction_id = result->getDataInt("transaction_id");
				bool onlyoffers = result->getDataInt("onlyoffers");

				CreatureEventList events = getCreatureEvents(CREATURE_EVENT_INSERT_MARKET_ALLOFFERS);
				for(CreatureEventList::iterator it = events.begin(); it != events.end(); ++it) {
					(*it)->executeInsertMarketAllOffers(this, item_id, item_name, item_seller, amount, price, gender, level, ispokemon, attributes, description, row_count, row_count_id, item_time, transaction_id, onlyoffers, page_counts);
				}
			}

			if (result->getDataString("ispokemon") == "Stones" && category == "Stones") {
				uint16_t item_id = result->getDataInt("item_id");
				uint16_t amount = result->getDataInt("amount");
				uint64_t price = result->getDataInt("price");
				uint16_t gender = result->getDataInt("gender");
				uint16_t level = result->getDataInt("level");

				std::string item_seller = result->getDataString("item_seller");
				std::string item_name = result->getDataString("item_name");
				std::string ispokemon = result->getDataString("ispokemon");

				uint64_t attrSize = 0;
				const char* attr = result->getDataStream("attributes", attrSize);
				std::string attributes = db->escapeBlob(attr, attrSize).c_str();
				std::string description = result->getDataString("description");

				uint16_t row_count_id = result->getDataInt("id");
				uint64_t item_time = result->getDataInt("item_time");
				row_count = row_count + 1;

				uint64_t transaction_id = result->getDataInt("transaction_id");
				bool onlyoffers = result->getDataInt("onlyoffers");

				CreatureEventList events = getCreatureEvents(CREATURE_EVENT_INSERT_MARKET_ALLOFFERS);
				for(CreatureEventList::iterator it = events.begin(); it != events.end(); ++it) {
					(*it)->executeInsertMarketAllOffers(this, item_id, item_name, item_seller, amount, price, gender, level, ispokemon, attributes, description, row_count, row_count_id, item_time, transaction_id, onlyoffers, page_counts);
				}
			}

			if (category == "All") {
				uint16_t item_id = result->getDataInt("item_id");
				uint16_t amount = result->getDataInt("amount");
				uint64_t price = result->getDataInt("price");
				uint16_t gender = result->getDataInt("gender");
				uint16_t level = result->getDataInt("level");

				std::string item_seller = result->getDataString("item_seller");
				std::string item_name = result->getDataString("item_name");
				std::string ispokemon = result->getDataString("ispokemon");

				uint64_t attrSize = 0;
				const char* attr = result->getDataStream("attributes", attrSize);
				std::string attributes = db->escapeBlob(attr, attrSize).c_str();
				std::string description = result->getDataString("description");

				uint16_t row_count_id = result->getDataInt("id");
				uint64_t item_time = result->getDataInt("item_time");
				row_count = row_count + 1;

				uint64_t transaction_id = result->getDataInt("transaction_id");
				bool onlyoffers = result->getDataInt("onlyoffers");

				CreatureEventList events = getCreatureEvents(CREATURE_EVENT_INSERT_MARKET_ALLOFFERS);
				for(CreatureEventList::iterator it = events.begin(); it != events.end(); ++it) {
					(*it)->executeInsertMarketAllOffers(this, item_id, item_name, item_seller, amount, price, gender, level, ispokemon, attributes, description, row_count, row_count_id, item_time, transaction_id, onlyoffers, page_counts);
				}
			}

        } while(result->next());
        
		result->free();
	}

	return true;
}

bool Player::sendMarketSearch(std::string type, std::string category)
{
	Database* db = Database::getInstance();
    DBResult* result = NULL;
    std::ostringstream query;

	uint16_t row_count = 0;
	uint16_t page_counts = 0;
	
	query.str("");
	query << "SELECT `page_numeration` FROM `players_marketoffers` ORDER BY page_numeration DESC LIMIT 1;";
	if ((result = db->storeQuery(query.str()))) {
		page_counts = result->getDataInt("page_numeration");
	}
	
	query.str("");
	query << "SELECT `item_id`, `item_name`, `item_seller`, `amount`, `price`, `gender`, `level`, `ispokemon`, `attributes`, `description`, `id`, `item_time`, `transaction_id`, `onlyoffers` FROM `players_marketoffers` WHERE `item_name` = '" << type << "' AND `category` = '" << category << "';";
	if ((result = db->storeQuery(query.str()))) {
		do {
			uint16_t item_id = result->getDataInt("item_id");
			uint16_t amount = result->getDataInt("amount");
			uint64_t price = result->getDataInt("price");
			uint16_t gender = result->getDataInt("gender");
			uint16_t level = result->getDataInt("level");

			std::string item_seller = result->getDataString("item_seller");
			std::string item_name = result->getDataString("item_name");
			std::string ispokemon = result->getDataString("ispokemon");
			
			//std::cout << "Items da Categoria; " << item_name << " - Pagina: " << page_numeration << std::endl;

			uint64_t attrSize = 0;
			const char* attr = result->getDataStream("attributes", attrSize);
			std::string attributes = db->escapeBlob(attr, attrSize).c_str();
			std::string description = result->getDataString("description");

			uint16_t row_count_id = result->getDataInt("id");
			uint64_t item_time = result->getDataInt("item_time");
			row_count = row_count + 1;

			uint64_t transaction_id = result->getDataInt("transaction_id");
			bool onlyoffers = result->getDataInt("onlyoffers");

			CreatureEventList events = getCreatureEvents(CREATURE_EVENT_INSERT_MARKET_ALLOFFERS);
			for(CreatureEventList::iterator it = events.begin(); it != events.end(); ++it) {
				(*it)->executeInsertMarketAllOffers(this, item_id, item_name, item_seller, amount, price, gender, level, ispokemon, attributes, description, row_count, row_count_id, item_time, transaction_id, onlyoffers, page_counts);
			}

        } while(result->next());
        
		result->free();
	}
	
	return true;
}
//

// Thalles Vitor - Auto Loot
void Player::addAutoLootItem(const std::string& name)
{
    loot.push_front(name);
}

void Player::removeAutoLootItem(const std::string& name)
{
    loot.remove(name);
}

void Player::setEnabledAutoLoot(bool option)
{
	lootEnabled = option;
}

bool Player::getEnabledAutoLoot()
{
	return lootEnabled;
}

// Thalles Vitor - PokeBar
bool Player::selectPokeball(uint16_t pokeballsNumber)
{
	Item* bp = getInventoryItem(SLOT_BACKPACK);
	if (!bp) {
		return false;
	}

	Container* container = bp->getContainer();
	if (!container) {
		return false;
	}

	// Backpack
	for(ContainerIterator it = container->begin(), end = container->end(); it != end; ++it)
    {
		Item* item = (*it);
		if (!item)
			continue;

		Container* itemC = item->getContainer();
		if (itemC) {
			for(ContainerIterator it = itemC->begin(), end = itemC->end(); it != end; ++it)
			{
				Item* item = (*it);
				if (!item)
					continue;

				const int32_t* v = item->getIntegerAttribute("numeration");
				if (!v)
					continue;

				if (v) {
					if (*v == pokeballsNumber) {
						Item* feet = getInventoryItem(SLOT_FEET);
						if (!feet) {
							ReturnValue ret = g_game.internalMoveItem(NULL, item->getParent(), this, INDEX_WHEREEVER, item, item->getItemCount(), 0);
							if(ret != RET_NOERROR) {
								return false;
							}

							return true;
						}
							
						if (item == feet) {
							return false;
						}

						ReturnValue ret = g_game.internalMoveItem(NULL, feet->getParent(), this, INDEX_WHEREEVER, feet, feet->getItemCount(), 0);
						if(ret != RET_NOERROR) {
							return false;
						}

						ReturnValue ret2 = g_game.internalMoveItem(NULL, item->getParent(), this, INDEX_WHEREEVER, item, item->getItemCount(), 0);
						if(ret2 != RET_NOERROR) {
							return false;
						}
							
						return true;
					}
				}
			}
		}
		else {
			const int32_t* v = item->getIntegerAttribute("numeration");
			if (!v)
				continue;

			if (v) {
				if (*v == pokeballsNumber) {
					Item* feet = getInventoryItem(SLOT_FEET);
					if (!feet) {
						ReturnValue ret = g_game.internalMoveItem(NULL, item->getParent(), this, INDEX_WHEREEVER, item, item->getItemCount(), 0);
						if(ret != RET_NOERROR) {
							return false;
						}

						return true;
					}
						
					if (item == feet) {
						return false;
					}

					ReturnValue ret = g_game.internalMoveItem(NULL, feet->getParent(), this, INDEX_WHEREEVER, feet, feet->getItemCount(), 0);
					if(ret != RET_NOERROR) {
						return false;
					}

					ReturnValue ret2 = g_game.internalMoveItem(NULL, item->getParent(), this, INDEX_WHEREEVER, item, item->getItemCount(), 0);
					if(ret2 != RET_NOERROR) {
						return false;
					}
						
					return true;
				}
			}
		}
	}
	
	// Coins
	Item* coins = getInventoryItem(SLOT_AMMO);
	if (!coins) {
		return false;
	}

	Container* coinsC = coins->getContainer();
	if (!coinsC) {
		return false;
	}

	for(ContainerIterator it = coinsC->begin(), end = coinsC->end(); it != end; ++it)
    {
		Item* item = (*it);
		if (!item)
			continue;

		Container* containerC = item->getContainer();
		if (containerC) {
			for(ContainerIterator it = containerC->begin(), end = containerC->end(); it != end; ++it)
			{
				Item* item = (*it);
				if (!item)
					continue;

				const int32_t* v = item->getIntegerAttribute("numeration");
				if (!v)
					continue;

				if (v) {
					if (*v == pokeballsNumber) {
						Item* feet = getInventoryItem(SLOT_FEET);
						if (!feet) {
							ReturnValue ret = g_game.internalMoveItem(NULL, item->getParent(), this, INDEX_WHEREEVER, item, item->getItemCount(), 0);
							if(ret != RET_NOERROR) {
								return false;
							}

							return true;
						}
						
						if (item == feet) {
							return false;
						}

						ReturnValue ret = g_game.internalMoveItem(NULL, feet->getParent(), this, INDEX_WHEREEVER, feet, feet->getItemCount(), 0);
						if(ret != RET_NOERROR) {
							return false;
						}

						ReturnValue ret2 = g_game.internalMoveItem(NULL, item->getParent(), this, INDEX_WHEREEVER, item, item->getItemCount(), 0);
						if(ret2 != RET_NOERROR) {
							return false;
						}
						
						return true;
					}
				}
			}
		}
		else {
			const int32_t* v = item->getIntegerAttribute("numeration");
			if (!v)
				continue;

			if (v) {
				if (*v == pokeballsNumber) {
					Item* feet = getInventoryItem(SLOT_FEET);
					if (!feet) {
						ReturnValue ret = g_game.internalMoveItem(NULL, item->getParent(), this, INDEX_WHEREEVER, item, item->getItemCount(), 0);
						if(ret != RET_NOERROR) {
							return false;
						}

						return true;
					}
					
					if (item == feet) {
						return false;
					}

					ReturnValue ret = g_game.internalMoveItem(NULL, feet->getParent(), this, INDEX_WHEREEVER, feet, feet->getItemCount(), 0);
					if(ret != RET_NOERROR) {
						return false;
					}

					ReturnValue ret2 = g_game.internalMoveItem(NULL, item->getParent(), this, INDEX_WHEREEVER, item, item->getItemCount(), 0);
					if(ret2 != RET_NOERROR) {
						return false;
					}
					
					return true;
				}
			}
		}
	}

	// PokeBag
	Item* pokebag = getInventoryItem(SLOT_HEAD);
	if (!pokebag) {
		return false;
	}

	Container* pokeBagC = pokebag->getContainer();
	if (!pokeBagC) {
		return false;
	}

	for(ContainerIterator it = pokeBagC->begin(), end = pokeBagC->end(); it != end; ++it)
	{
		Item* item = (*it);
		if (!item)
			continue;

		const int32_t* v = item->getIntegerAttribute("numeration");
		if (!v)
			continue;

		if (v) {
			if (*v == pokeballsNumber) {
				Item* feet = getInventoryItem(SLOT_FEET);
				if (!feet) {
					ReturnValue ret = g_game.internalMoveItem(NULL, item->getParent(), this, INDEX_WHEREEVER, item, item->getItemCount(), 0);
					if(ret != RET_NOERROR) {
						return false;
					}

					return true;
				}
						
				if (item == feet) {
					return false;
				}

				ReturnValue ret = g_game.internalMoveItem(NULL, feet->getParent(), this, INDEX_WHEREEVER, feet, feet->getItemCount(), 0);
				if(ret != RET_NOERROR) {
					return false;
				}

				ReturnValue ret2 = g_game.internalMoveItem(NULL, item->getParent(), this, INDEX_WHEREEVER, item, item->getItemCount(), 0);
				if(ret2 != RET_NOERROR) {
					return false;
				}
						
				return true;
			}
		}
	}

	return false;
}

std::string Player::getStatus() const
{
	return status;
}