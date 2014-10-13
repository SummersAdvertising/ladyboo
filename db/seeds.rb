# encoding: UTF-8
#Admin.create :name => 'SuperAdmin', :email => "adam@summers.com.tw", :password => "23219217"

# Category.create({parent_id: 0, name: '分類列表', depth: 0})
# Category.create({parent_id: 1, name: 'Ladyboo', depth: 1})

# topic testing 
Topic.create([{name: 'Topic-1'},{name: 'Topic-2'},{name: 'Topic-3'},{name: 'Topic-4'}])
# pre-request: product_id 5~8
TopicProductship.create([{topic_id: 1, product_id: 5 },{topic_id: 1, product_id: 6 },{topic_id: 2, product_id: 6 },{topic_id: 2, product_id: 7 },{topic_id: 3, product_id: 7 },
  {topic_id: 3, product_id: 8 },{topic_id: 3, product_id: 5 },{topic_id: 4, product_id: 5 },{topic_id: 4, product_id: 6 },{topic_id: 4, product_id: 7 },{topic_id: 4, product_id: 8 }])

Lookbook.create([{name: 'look-1'},{name: 'look-2'},{name: 'look-3'},{name: 'look-4'}])

LookbookTopicship.create([{lookbook_id: 1, topic_id: 1},{lookbook_id: 2, topic_id: 1},{lookbook_id: 2, topic_id: 2},{lookbook_id: 3, topic_id: 1},{lookbook_id: 3, topic_id: 2},{lookbook_id: 3, topic_id: 3},{lookbook_id: 4, topic_id: 1},{lookbook_id: 4, topic_id: 2},{lookbook_id: 4, topic_id: 3},{lookbook_id: 4, topic_id: 4}])

TopicCollection.create([{name: 'collect-1'},{name: 'collect-2'},{name: 'collect-3'},{name: 'collect-4'}])

TopicCollectionTopicship.create([{topic_collection_id: 1, topic_id: 1},{topic_collection_id: 2, topic_id: 1},{topic_collection_id: 3, topic_id: 2},{topic_collection_id: 4, topic_id: 1}])