class CreateDomains < ActiveRecord::Migration[5.2]
  def change
    create_table :domains do |t|
      t.string :domain_name, null: false
      t.string :country
      t.boolean :redirect_to_https, default: false
      t.integer :rank, default: 0, null: false

      t.timestamps
    end
    add_index :domains, :domain_name, unique: true
    add_index :domains, :country
    add_index :domains, :redirect_to_https
    add_index :domains, :rank
  end
end
