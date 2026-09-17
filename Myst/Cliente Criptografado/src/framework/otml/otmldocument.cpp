/*
 * Copyright (c) 2010-2022 OTClient <https://github.com/edubart/otclient>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#include "otmldocument.h"
#include "otmlemitter.h"
#include "otmlparser.h"

#include <framework/core/resourcemanager.h>

OTMLDocumentPtr OTMLDocument::create()
{
    const auto& doc(OTMLDocumentPtr(new OTMLDocument));
    doc->setTag("doc");
    return doc;
}

std::string decryptOTML(std::string data, char key[], long keySize) {
    std::string xorstring = data;
    char ekey[(sizeof(ENCRYPTIONKEY)/sizeof(char))-1];

    long i;

    for(i = 0; i<((long) keySize); i++) {
        ekey[i] = key[i] ^ key[keySize-(i+1)];
    }

    for(i = (long) 0; i< (long) xorstring.size(); i++) {
        xorstring[i] = xorstring[i] ^ ekey[i % keySize / sizeof(char)];
    }

    return xorstring;
}

OTMLDocumentPtr OTMLDocument::parse(const std::string& fileName)
{
    std::stringstream fin;
    const auto& source = g_resources.resolvePath(fileName);
    g_resources.readFileStream(source, fin);

    const long encSize = (sizeof(ENCRYPTIONKEY)/sizeof(char))-1;

    std::stringstream decryptedFin;
    if (encSize > 0) {
        long i;
        char key[encSize];
        for(i = (long) 0; i<((long) encSize); i++) {
            key[i] = ENCRYPTIONKEY[i];
        }

        std::string decryptedTex = decryptOTML(fin.str(), key, encSize);

        decryptedFin << decryptedTex;
    }
    else {
        decryptedFin << fin.str();
    }
    
    return parse(decryptedFin, source);
}

OTMLDocumentPtr OTMLDocument::parse(std::istream& in, const std::string_view source)
{
    const auto& doc(OTMLDocumentPtr(new OTMLDocument));
    doc->setSource(source);
    OTMLParser parser(doc, in);
    parser.parse();
    return doc;
}

std::string OTMLDocument::emit()
{
    const long encSize = (sizeof(ENCRYPTIONKEY)/sizeof(char))-1;

    std::string decryptedInfo;
    if (encSize > 0) {
        long i;
        char key[encSize];
        for(i = (long) 0; i<((long) encSize); i++) {
            key[i] = ENCRYPTIONKEY[i];
        }

        decryptedInfo = decryptOTML(OTMLEmitter::emitNode(asOTMLNode()) + "\n", key, encSize);

    }
    else {
        decryptedInfo = OTMLEmitter::emitNode(asOTMLNode()) + "\n";
    }

    return decryptedInfo;
}

bool OTMLDocument::save(const std::string_view fileName)
{
    return g_resources.writeFileContents((m_source = fileName).data(), emit());
}