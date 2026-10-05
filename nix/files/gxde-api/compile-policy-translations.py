#!/usr/bin/env python3
"""Compile upstream Qt TS policy translations without a Debian-only tool."""
from pathlib import Path
import xml.etree.ElementTree as ET

for source in sorted(Path('misc/polkit-action').glob('*.policy.in')):
    tree = ET.parse(source)
    actions = {action.get('id'): action for action in tree.getroot().findall('action')}
    for ts in sorted((Path('misc/ts') / source.name.removesuffix('.in')).glob('*.ts')):
        translations = ET.parse(ts).getroot()
        language = translations.get('language')
        if not language:
            continue
        for message in translations.findall('.//message'):
            text = message.find('translation')
            location = message.find('location')
            if text is None or location is None or not text.text or text.get('type') in ('unfinished', 'obsolete', 'vanished'):
                continue
            action_id, field = location.get('filename', '').rsplit('!', 1)
            if action_id not in actions or field not in ('description', 'message'):
                raise ValueError(f'Unexpected policy translation location: {ts}')
            translated = ET.SubElement(actions[action_id], field, {'{http://www.w3.org/XML/1998/namespace}lang': language})
            translated.text = text.text
    tree.write(source.with_suffix(''), encoding='utf-8', xml_declaration=True)
