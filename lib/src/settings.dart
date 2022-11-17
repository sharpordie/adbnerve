enum Dialect {
  caEs('ca-ES', 'Català'),
  csCz('cs-CZ', 'Čeština'),
  daDk('da-DK', 'Dansk'),
  deDe('de-DE', 'Deutsch'),
  enAu('en-AU', 'English (Australia)'),
  enCa('en-CA', 'English (Canada)'),
  enGb('en-GB', 'English (United Kingdom)'),
  enNz('en-NZ', 'English (New Zealand)'),
  enUs('en-US', 'English (United States)'),
  esEs('es-ES', 'Español (España)'),
  esUs('es-US', 'Español (Estados Unidos)'),
  fiPh('fil-PH', 'Filipino'),
  frCa('fr-CA', 'Français (Canada)'),
  frFr('fr-FR', 'Français (France)'),
  hrHr('hr-HR', 'Hrvatski'),
  idId('id-ID', 'Indonesia'),
  itIt('it-IT', 'Italiano'),
  lvLv('lv-LV', 'Latviešu'),
  jaJp('ja-JP', '日本語');

  const Dialect(this.compact, this.content);

  final String compact;
  final String content;
}
