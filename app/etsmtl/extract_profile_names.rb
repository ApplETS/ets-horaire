class ExtractProfileNames
  PROFILES_NODE_ID = 'plc_lt_zoneMain_pageplaceholder_pageplaceholder_lt_zoneContent_pageplaceholder_pageplaceholder_lt_zoneCenter_pageplaceholder_pageplaceholder_lt_zoneLeft_repeater_repItems_ctl00_ctl00_PanelConditionsAdmission'
  PROFILE_TITLE = /Profil d'accueil ([A-Z]+) \(.+\)/
  PROFILE_LETTER_INDEX = 1

  def self.from(document)
    profiles = []
    document.css("##{PROFILES_NODE_ID} strong").each do |strong_node|
      profile_matches = PROFILE_TITLE.match(strong_node.text)
      profiles << profile_matches[PROFILE_LETTER_INDEX] unless profile_matches.nil?
    end
    profiles
  end
end