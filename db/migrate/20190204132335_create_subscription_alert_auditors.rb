class CreateSubscriptionAlertAuditors < ActiveRecord::Migration[5.2]
  def change
    create_table :subscription_alert_auditors, id: :uuid do |t|
      t.references :subscription, foreign_key: true, type: :uuid
      t.date :date
      t.integer :attempt, default: 0
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
