require 'spec_helper'

describe Type do

  # resources
  let!(:light1)    { FactoryGirl.create :device }
  let!(:type)      { Type.find light1.type_id }
  let!(:status)    { Property.find(type.property_ids.first) }
  let!(:intensity) { Property.find(type.property_ids.last) }
  let!(:light2)    { FactoryGirl.create :device, type_id: type.id }
  let!(:alarm)     { FactoryGirl.create :device }

  # back in time
  let!(:light1_updated_at) { light1.update_attributes(updated_at: Time.now-60); light1.updated_at }
  let!(:light2_updated_at) { light2.update_attributes(updated_at: Time.now-60); light2.updated_at }


  describe 'when updating a property' do

    describe 'when a device is not active' do

      before { light1.update_attributes(activated_at: nil) }

      context 'when the default field of a property is updated' do

        before { status.update_attributes(default: 'updated') }

        it 'updates the value field in the property device' do
          light1.reload.properties.where(id: status.id).first.value.should == 'updated'
        end

        it 'touches the device changing updated_at' do
          light1.reload.updated_at.should be_within(1).of(Time.now)
        end

        it 'does not update devices with different properties' do
          alarm.reload.properties.first.value.should_not == 'updated'
          alarm.reload.properties.last.value.should_not  == 'updated'
        end
      end

      context 'when the suggested field of a property is updated' do

        before { status.update_attributes(suggested: { updated: 'updated' }) }

        it 'updates the suggested field in the property device' do
          light1.reload.properties.where(id: status.id).first.suggested.should == { 'updated' => 'updated' }
        end

        it 'touches the device changing updated_at' do
          light1.reload.updated_at.should be_within(1).of(Time.now)
        end

        it 'does not update devices with different properties' do
          alarm.reload.properties.first.value.should_not == { updated: 'updated' }
          alarm.reload.properties.last.value.should_not  == { updated: 'updated' }
        end
      end
    end

    # when a device is already activated its value is can't be changed
    describe 'when a device is active' do

      context 'when the default field of a property is updated' do

        before { status.update_attributes(default: 'updated') }

        it 'does not update the value field in the property device' do
          light1.reload.properties.where(id: status.id).first.value.should == 'off'
        end
      end
    end
  end

  describe 'when adding a property to the light type' do

    let(:random) { FactoryGirl.create(:property) }
    before       { type.update_attributes(property_ids: [status.id, intensity.id, random.id]) }

    it 'adds the new property to all lights' do
      light1.reload.properties.last.id.should == random.id
      light2.reload.properties.last.id.should == random.id
    end

    it 'touches the device changing updated_at' do
      light1.reload.updated_at.should be_within(1).of(Time.now)
      light2.reload.updated_at.should be_within(1).of(Time.now)
    end

    it 'sets the light properties to three' do
      light1.reload.properties.should have(3).properties
      light2.reload.properties.should have(3).properties
    end

    it 'does not add the new property to the alarm' do
      alarm.properties.last.id.should_not == random.id
      alarm.reload.properties.should have(2).properties
    end
  end

  describe 'when removing a property' do

    before { type.update_attributes(property_ids: [status.id]) }

    it 'adds the new property to all lights' do
      light1.reload.properties.last.id.should == status.id
      light2.reload.properties.last.id.should == status.id
    end

    it 'touches the device changing updated_at' do
      light1.reload.updated_at.should be_within(1).of(Time.now)
      light2.reload.updated_at.should be_within(1).of(Time.now)
    end

    it 'sets the light properties to three' do
      light1.reload.properties.should have(1).properties
      light2.reload.properties.should have(1).properties
    end

    it 'does not add the new property to the alarm' do
      alarm.properties.last.id.should_not == intensity.id
      alarm.reload.properties.should have(2).properties
    end
  end

  describe 'when adding and removing a property' do
    let(:random) { FactoryGirl.create(:property) }
    before       { type.update_attributes(property_ids: [status.id, random.id]) }

    it 'adds the new property to all lights' do
      light1.reload.properties.last.id.should == random.id
      light2.reload.properties.last.id.should == random.id
    end

    it 'touches the device changing updated_at' do
      light1.reload.updated_at.should be_within(1).of(Time.now)
      light2.reload.updated_at.should be_within(1).of(Time.now)
    end

    it 'sets the light properties to three' do
      light1.reload.properties.should have(2).properties
      light2.reload.properties.should have(2).properties
    end

    it 'does not add the new property to the alarm' do
      alarm.properties.last.id.should_not == random.id
      alarm.reload.properties.should have(2).properties
    end
  end
end
