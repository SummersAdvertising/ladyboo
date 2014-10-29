# encoding: UTF-8
#Admin.create :name => 'SuperAdmin', :email => "adam@summers.com.tw", :password => "23219217"

# Category.create({parent_id: 0, name: '分類列表', depth: 0})
# Category.create({parent_id: 1, name: 'Ladyboo', depth: 1})

# topic testing 
# Topic.create([{name: 'Topic-1'},{name: 'Topic-2'},{name: 'Topic-3'},{name: 'Topic-4'}])
# # pre-request: product_id 5~8
# TopicProductship.create([{topic_id: 1, product_id: 5 },{topic_id: 1, product_id: 6 },{topic_id: 2, product_id: 6 },{topic_id: 2, product_id: 7 },{topic_id: 3, product_id: 7 },
#   {topic_id: 3, product_id: 8 },{topic_id: 3, product_id: 5 },{topic_id: 4, product_id: 5 },{topic_id: 4, product_id: 6 },{topic_id: 4, product_id: 7 },{topic_id: 4, product_id: 8 }])

# Lookbook.create([{name: 'look-1'},{name: 'look-2'},{name: 'look-3'},{name: 'look-4'}])

# 要加入tile ? #

# LookbookTopicship.create([{lookbook_id: 1, topic_id: 1},{lookbook_id: 2, topic_id: 1},{lookbook_id: 2, topic_id: 2},{lookbook_id: 3, topic_id: 1},{lookbook_id: 3, topic_id: 2},{lookbook_id: 3, topic_id: 3},{lookbook_id: 4, topic_id: 1},{lookbook_id: 4, topic_id: 2},{lookbook_id: 4, topic_id: 3},{lookbook_id: 4, topic_id: 4}])

# TopicCollection.create([{name: 'collect-1'},{name: 'collect-2'},{name: 'collect-3'},{name: 'collect-4'}])

# TopicCollectionTopicship.create([{topic_collection_id: 1, topic_id: 1},{topic_collection_id: 2, topic_id: 1},{topic_collection_id: 3, topic_id: 2},{topic_collection_id: 4, topic_id: 1}])

#運送方式
# Delivery.create({name: '本島', tracking_url: 'http://www.t-cat.com.tw/inquire/trace.aspx', normal_fee: 80, shipping_condition: 'taiwan', iscod: 'no', discount_criteria: 800 ,discount_fee: 0})
# Delivery.create({name: '離島', tracking_url: 'http://postserv.post.gov.tw/webpost/CSController?cmd=POS4001_1&_SYS_ID=D&_MENU_ID=189&_ACTIVE_ID=190', normal_fee: 100, shipping_condition: 'island', iscod: 'no', discount_criteria: 800 ,discount_fee: 0})
# Delivery.create({name: '海外', tracking_url: 'http://postserv.post.gov.tw/webpost/CSController?cmd=POS4001_1&_SYS_ID=D&_MENU_ID=189&_ACTIVE_ID=190', normal_fee: 600, shipping_condition: 'overseas', iscod: 'no', discount_criteria: 6000 ,discount_fee: 0})

#user role
# Role.create({name: 'member'})