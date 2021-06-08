#!/usr/bin/env node
const fs = require('fs');
const util = require('util');
const readFile = util.promisify(fs.readFile);
const writeFile = util.promisify(fs.writeFile);

function removeContainerInfo(json) {
    const removeVersionAndAccount = t => {
        t.containerId = '0000000000';
        t.accountId = '0000000000';
        return t;
    };
    json.containerVersion.path = '';
    json.containerVersion.accountId = '0000000000';
    json.containerVersion.containerId = '0000000000';
    json.containerVersion.tagManagerUrl = '';
    json.containerVersion.container.path = '';
    json.containerVersion.container.accountId = '0000000000';
    json.containerVersion.container.containerId = '0000000000';
    json.containerVersion.container.name = '';
    json.containerVersion.container.publicId = '';
    json.containerVersion.container.tagManagerUrl = '';
    json.containerVersion.tag = json.containerVersion.tag.map(removeVersionAndAccount);
    json.containerVersion.trigger = json.containerVersion.trigger.map(removeVersionAndAccount);
    json.containerVersion.variable = json.containerVersion.variable.map(removeVersionAndAccount);
    json.containerVersion.folder = json.containerVersion.folder.map(removeVersionAndAccount);
    return json;
}

function removeBuiltins(json) {
    json.containerVersion.builtInVariable = [];
    return json;
}

function removeFolders(json) {
    json.containerVersion.folder = json.containerVersion.folder.filter(folder => folder.name.includes('Olo Serve'));
    return json;
}

function removeUAID(json) {
    const ga = json.containerVersion.variable.find(v => v.type === 'gas');
    if (ga) {
        const param = ga.parameter.find(p => p.key === 'trackingId');
        if (param) param.value = '';
    }
    return json;
}

async function writeContainer(json, path) {
    path = `olo-serve-container-configuration-${path}.json`;
    await writeFile(path, JSON.stringify(json, null, 4));
}

function includesAny(str, arr) {
    return !!arr.find(a => str.includes(a));
}

function filter(json, ...strs) {
    json = JSON.parse(JSON.stringify(json));
    json.containerVersion.tag = json.containerVersion.tag.filter(tag => includesAny(tag.name, strs));
    json.containerVersion.trigger = json.containerVersion.trigger.filter(trigger => includesAny(trigger.name, strs));
    json.containerVersion.variable = json.containerVersion.variable.filter(variable => includesAny(variable.name, strs));
    return json;
}

(async function main() {
    const args = process.argv;
    const source = args[2];

    if (!source) throw new Error('You must provide a path to a GTM container template file!');
    
    const raw = await readFile(source, { encoding: 'utf-8' });
    let json = JSON.parse(raw);

    // Remove container information
    json = removeContainerInfo(json);

    // Remove built in variables
    json = removeBuiltins(json);

    // Remove non-Serve folders
    json = removeFolders(json, 'Olo Serve');

    // Remove UA IDs
    json = removeUAID(json);

    // All
    await writeContainer(filter(json, 'Olo Serve'), 'all');

    // GA4 All
    await writeContainer(filter(json, '- GA4', 'Olo Serve - Is', 'Olo Serve - DOM Ready'), 'ga4-all');
    // GA4 Web
    await writeContainer(filter(json, 'GA4 - Ecommerce', 'Olo Serve - Is', 'Integration - GA4', 'Olo Serve - GA4 - Web', 'Olo Serve - DOM Ready'), 'ga4-web');
    // GA4 iOS
    await writeContainer(filter(json, 'GA4 - Ecommerce', 'Olo Serve - Is', 'Integration - GA4', 'Olo Serve - GA4 - iOS', 'Olo Serve - DOM Ready'), 'ga4-ios');
    // GA4 Android
    await writeContainer(filter(json, 'GA4 - Ecommerce', 'Olo Serve - Is', 'Integration - GA4', 'Olo Serve - GA4 - Android', 'Olo Serve - DOM Ready'), 'ga4-android');

    // UA All
    await writeContainer(filter(json, '- UA', 'Olo Serve - Is', 'Olo Serve - DOM Ready'), 'ua-all');
    // UA Web
    await writeContainer(filter(json, 'UA - Google Analytics', 'Olo Serve - Is', 'Integration - UA', 'Olo Serve - UA - Web', 'Olo Serve - DOM Ready'), 'ua-web');
    // UA iOS
    await writeContainer(filter(json, 'UA - Google Analytics', 'Olo Serve - Is', 'Integration - UA', 'Olo Serve - UA - iOS', 'Olo Serve - DOM Ready'), 'ua-ios');
    // UA Android
    await writeContainer(filter(json, 'UA - Google Analytics', 'Olo Serve - Is', 'Integration - UA', 'Olo Serve - UA - Android', 'Olo Serve - DOM Ready'), 'ua-android');
})();