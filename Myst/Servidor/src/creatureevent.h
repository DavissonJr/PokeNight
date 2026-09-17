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

#ifndef __CREATUREEVENT__
#define __CREATUREEVENT__
#include "enums.h"

#include "baseevents.h"
#include "tile.h"

enum CreatureEventType_t
{
	CREATURE_EVENT_NONE,
	CREATURE_EVENT_LOGIN,
	CREATURE_EVENT_LOGOUT,
	CREATURE_EVENT_CHANNEL_JOIN,
	CREATURE_EVENT_CHANNEL_LEAVE,
	CREATURE_EVENT_ADVANCE,
	CREATURE_EVENT_LOOK,
	CREATURE_EVENT_DIRECTION,
	CREATURE_EVENT_OUTFIT,
	CREATURE_EVENT_MAIL_SEND,
	CREATURE_EVENT_MAIL_RECEIVE,
	CREATURE_EVENT_TRADE_REQUEST,
	CREATURE_EVENT_TRADE_ACCEPT,
	CREATURE_EVENT_TEXTEDIT,
	CREATURE_EVENT_REPORTBUG,
	CREATURE_EVENT_THINK,
	CREATURE_EVENT_STATSCHANGE,
	CREATURE_EVENT_COMBAT_AREA,
	CREATURE_EVENT_PUSH,
	CREATURE_EVENT_TARGET,
	CREATURE_EVENT_FOLLOW,
	CREATURE_EVENT_COMBAT,
	CREATURE_EVENT_ATTACK,
	CREATURE_EVENT_CAST,
	CREATURE_EVENT_KILL,
	CREATURE_EVENT_DEATH,
	CREATURE_EVENT_PREPAREDEATH,
	CREATURE_EVENT_SPAWN,
	CREATURE_EVENT_EXTENDED_OPCODE, // otclient additional network opcodes
	CREATURE_EVENT_MOVEITEM,
	CREATURE_EVENT_WALK, // Thalles Vitor
	CREATURE_EVENT_INSERT_MARKETITEM, // market insert item - thalles vitor
	CREATURE_EVENT_INSERT_MARKET_MYOFFERS, // market insert my offers in seller - thalles vitor
	CREATURE_EVENT_INSERT_MARKET_ALLOFFERS, // market insert all offers in buy - thalles vitor
	CREATURE_EVENT_INSERT_MARKETBUYOFFER_UPDATE, // update market window (all offers, my offers) after buy item from market - thalles vitor
	CREATURE_EVENT_INSERT_MARKET_MYHISTORIC, // market insert my historic buyed of items - thalles vitor
	CREATURE_EVENT_INSERT_MARKET_MAKEOFFREMOVEITEM, // market make offer remove the item in pushed to slot - thalles vitor
	CREATURE_EVENT_INSERT_MARKET_UPDATEOFFERS, // market update makered offers - thalles vitor
	CREATURE_EVENT_INSERT_MARKET_OFFERSTOME, // market insert all offers to me - thalles vitor
};

enum StatsChange_t
{
	STATSCHANGE_HEALTHGAIN,
	STATSCHANGE_HEALTHLOSS,
	STATSCHANGE_MANAGAIN,
	STATSCHANGE_MANALOSS
};

class CreatureEvent;
class CreatureEvents : public BaseEvents
{
	public:
		CreatureEvents();
		virtual ~CreatureEvents();

		// global events
		bool playerLogin(Player* player);
		bool playerLogout(Player* player, bool forceLogout);

		CreatureEvent* getEventByName(const std::string& name, bool forceLoaded = true);

	protected:
		virtual std::string getScriptBaseName() const {return "creaturescripts";}
		virtual void clear();

		virtual Event* getEvent(const std::string& nodeName);
		virtual bool registerEvent(Event* event, xmlNodePtr p, bool override);

		virtual LuaScriptInterface& getInterface() {return m_interface;}
		LuaScriptInterface m_interface;

		//creature events
		typedef std::map<std::string, CreatureEvent*> CreatureEventList;
		CreatureEventList m_creatureEvents;
};

struct DeathEntry;
typedef std::vector<DeathEntry> DeathList;

typedef std::map<uint32_t, Player*> UsersMap;
class CreatureEvent : public Event
{
	public:
		CreatureEvent(LuaScriptInterface* _interface);
		virtual ~CreatureEvent() {}

		virtual bool configureEvent(xmlNodePtr p);

		bool isLoaded() const {return m_isLoaded;}
		const std::string& getName() const {return m_eventName;}
		CreatureEventType_t getEventType() const {return m_type;}

		void copyEvent(CreatureEvent* creatureEvent);
		void clearEvent();

		//scripting
		uint32_t executeLogin(Player* player);
		uint32_t executeLogout(Player* player, bool forceLogout);
		uint32_t executeChannelJoin(Player* player, uint16_t channelId, UsersMap usersMap);
		uint32_t executeChannelLeave(Player* player, uint16_t channelId, UsersMap usersMap);
		uint32_t executeAdvance(Player* player, skills_t skill, uint32_t oldLevel, uint32_t newLevel);
		uint32_t executeLook(Player* player, Thing* thing, const Position& position, int16_t stackpos, int32_t lookDistance);
		uint32_t executeMailSend(Player* player, Player* receiver, Item* item, bool openBox);
		uint32_t executeMailReceive(Player* player, Player* sender, Item* item, bool openBox);
		uint32_t executeTradeRequest(Player* player, Player* target, Item* item);
		uint32_t executeTradeAccept(Player* player, Player* target, Item* item, Item* targetItem);
		uint32_t executeTextEdit(Player* player, Item* item, std::string newText);
		uint32_t executeReportBug(Player* player, std::string comment);
		uint32_t executeThink(Creature* creature, uint32_t interval);
		uint32_t executeDirection(Creature* creature, Direction old, Direction current);
		uint32_t executeOutfit(Creature* creature, const Outfit_t& old, const Outfit_t& current);
		uint32_t executeStatsChange(Creature* creature, Creature* attacker, StatsChange_t type, CombatType_t combat, int32_t value);
		uint32_t executeCombatArea(Creature* creature, Tile* tile, bool isAggressive);
		uint32_t executePush(Player* player, Creature* target);
		uint32_t executeTarget(Creature* creature, Creature* target);
		uint32_t executeFollow(Creature* creature, Creature* target);
		uint32_t executeCombat(Creature* creature, Creature* target);
		uint32_t executeAttack(Creature* creature, Creature* target);
		uint32_t executeCast(Creature* creature, Creature* target = NULL);
		uint32_t executeKill(Creature* creature, Creature* target, bool lastHit);
		uint32_t executeDeath(Creature* creature, Item* corpse, DeathList deathList);
		uint32_t executePrepareDeath(Creature* creature, DeathList deathList);
		uint32_t executeMoveItem(Player* player, Item* item, uint8_t count, const Position& fromPos, const Position& toPos, Item* toContainer, Item* fromContainer, int16_t fstack);
		uint32_t executeOnSpawn(Creature* creature);
		uint32_t executeExtendedOpcode(Creature* creature, uint8_t opcode, const std::string& buffer);
		uint32_t executeWalk(Creature* creature, const Position& oldPos, const Position& newPos); // Thalles Vitor
		//

		// Thalles Vitor - Market System
		uint32_t executeMarketInsert(Player* player, Item* item);
		uint32_t executeInsertMarketMyOffers(Player* player, uint16_t item_id, const std::string& item_name,
		uint64_t item_time, uint16_t amount, uint64_t price, uint16_t gender, uint16_t level, const std::string& ispokemon, 
		const std::string& attributes, const std::string& description, uint16_t row_count, uint16_t row_count_id, const std::string& type, uint64_t transaction_id, bool onlyoffers);
		uint32_t executeInsertMarketAllOffers(Player* player, uint16_t item_id, const std::string& item_name,
		const std::string& item_seller, uint16_t amount, uint64_t price, uint16_t gender, uint16_t level, const std::string& ispokemon, 
		const std::string& attributes, const std::string& description, uint16_t row_count, uint16_t row_count_id, uint64_t item_time, uint64_t transaction_id, bool onlyoffers, uint64_t page_numeration);
		uint32_t executeBuyOfferUpdateMarketWindow(Player* player);
		uint32_t executeInsertMarketHistoric(Player* player, const std::string& item_name, uint32_t amount, uint64_t date);
		uint32_t executeMarketOfferRemoveItem(Player* player, uint16_t item_id, const std::string& description, uint16_t amount);
		uint32_t executeMakeOffers(Player* player, uint16_t item_id, const std::string& item_name, const std::string& item_seller, uint16_t count_row, const std::string& description, uint64_t transaction_id);
		uint32_t executeMarketViewOffersToMe(Player* player, uint16_t item_id, const std::string& item_name, const std::string& description, uint64_t tempo, uint16_t count_row, uint64_t transaction_id);
		//

	protected:
		virtual std::string getScriptEventName() const;
		virtual std::string getScriptEventParams() const;

		bool m_isLoaded;
		std::string m_eventName;
		CreatureEventType_t m_type;
};
#endif
