shared_examples_for 'a type connection' do

  let(:field) { "#{connection.singularize}_ids" }

  describe '#find_connection' do

    context 'when creates' do

      context 'with valid IDs' do

        let(:type) { FactoryGirl.create :type, :with_no_connections, connection => ids }

        it 'sets the connections' do
          type[field].should == ids
        end
      end

      context 'with empty connections' do

        let(:type) { FactoryGirl.create :type, connection => [] }

        it 'removes previous connections' do
          type[field].should have(0).items
        end
      end
    end

    context 'when updates' do

      context 'with new connections' do

        let(:type)     { FactoryGirl.create :type }
        let!(:old_ids) { type[field] }

        before         { type.update_attributes connection => ids }
        let!(:new_ids) { type[field] }

        it 'sets the new connections' do
          new_ids.should_not == old_ids
        end
      end
    end
  end
end
