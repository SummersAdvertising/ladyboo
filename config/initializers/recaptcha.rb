Recaptcha.configure do |config|

  if Rails.env.production? 
    #Temporary: li750-66.members.linode.com
    config.public_key  = '6Le04_wSAAAAAB9vNpb1AHUgI6E50Y6ojF6SCP9g'
    config.private_key = '6Le04_wSAAAAAJHglo2Q4TR_lripR10Aw6YW2yiK'

  else 
    #Temporary: www.ladybootw.com, because localhost is ok
    config.public_key  = '6Le14_wSAAAAAMrvjXFXDvn8EvoA_hBmA8WjBB9g'
    config.private_key = '6Le14_wSAAAAADwR5NboXH_HAukOspkjnpkrTQYV'
    
  end
end