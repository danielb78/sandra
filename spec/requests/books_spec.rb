require 'rails_helper'

RSpec.describe 'Books', type: :request do

  let(:agile_rails) { create :agile_rails }
  let(:practical_ruby) { create :practical_ruby }
  let(:ecommerce_rails) { create :ecommerce_rails }

  let(:books) { [agile_rails, practical_ruby, ecommerce_rails] }

  describe 'GET /api/books' do
    before { books }

    context 'default behavior' do
      before { get '/api/books' }

      it 'receives HTTP status 200' do
        expect(response.status).to eq 200
      end

      it 'receives a json with the "data" root key' do
        expect(json_body['data']).to_not be_nil
      end

      it 'receives all 3 books' do
        expect(json_body['data'].size).to eq 3
      end
    end

    describe 'field picking' do
      context 'with the fields parameter' do
        before { get '/api/books?fields=id,title,author_id'}

        it 'gets books with only the id, title and author_id keys' do
          json_body['data'].each do |book|
            expect(book.keys).to eq ['id', 'title', 'author_id']
          end
        end
      end

      context 'without the fields parameter' do
        before { get '/api/books' }

        it 'gets books with all the fields specified in the presenter' do
          json_body['data'].each do |book|
            expect(book.keys).to eq BookPresenter.build_attributes.map(&:to_s)
          end
        end
      end
    end

    describe 'pagination' do
      context 'when asking for the first page' do
        before { get '/api/books?page=1&per=2' }

        it 'receives HTTP status 200' do
          expect(response.status).to eq 200
        end

        it 'receives only 2 books' do
          expect(json_body['data'].size).to eq 2
        end

        it 'receives a response with the Link header' do
          expect(response.headers['Link'].split(', ').first).to eq (
            '<http://www.example.com/api/books?page=2&per=2>; rel="next"'
                                                                   )
        end
      end

      context 'when asking for the next page' do
        before { get '/api/books?page=2&per=2' }

        it 'receives HTTP status 200' do
          expect(response.status).to eq 200
        end

        it 'receives only one book' do
          expect(json_body['data'].size).to eq 1
        end
      end

    end
  end
end