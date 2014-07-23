module Growbot
  class Api < Sinatra::Base
    helpers do
      def database
        @db ||= CouchRest.database!('http://127.0.0.1:5984/metrics')
      end

      def document(id)
        database.get(id).to_hash
      end
    end

    get '/' do
      docs = database.all_docs['rows'].map do |doc|
        document(doc['id'])
      end

      headers "Access-Control-Allow-Origin" => "*"
      json docs
    end

    post '/track' do
      dataset = database.save_doc(params.merge time: Time.now)

      json database.get(dataset['id']).to_hash
    end
  end
end
