Recaptcha.configure do |config|

  if Rails.env.production? 
    #Temporary: li750-66.members.linode.com
    config.public_key  = '6Le04_wSAAAAAB9vNpb1AHUgI6E50Y6ojF6SCP9g'
    config.private_key = '6Le04_wSAAAAAJHglo2Q4TR_lripR10Aw6YW2yiK'
    #Temporary: ladyboo.summers.com.tw
    #config.public_key  = '6Lcfov8SAAAAAEQIqnDw_03A3cHxAn5BpBQrvW08'
    #config.private_key = '6Lcfov8SAAAAAIEkbbgrEBMHl2kE-Sf1skpyfMee'
  else 
    #Temporary: www.ladyboo.com.tw, because localhost is ok
    config.public_key  = '6LcnugETAAAAAJa_fuFPBYfCtzqBt0E5HwD58WeJ'
    config.private_key = '6LcnugETAAAAAOQsd-HY9YDEAKeZqWH4c9uPhLb6'
  end

end