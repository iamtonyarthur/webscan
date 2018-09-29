class AddCertificateStatusToDomains < ActiveRecord::Migration[5.2]
  def change
    add_column :domains, :certificate_status, :string
    add_index :domains, :certificate_status
  end
end
