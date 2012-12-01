class CreatePusherChannels < ActiveRecord::Migration
  def change
    create_table :pusher_channels do |t|

      t.timestamps
    end
  end
end
