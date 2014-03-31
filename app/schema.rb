DB.transaction do
  DB.extension :pg_hstore

  DB.create_table?(:specimens) do
    String :nick, :size => 255, :primary_key => true
    String :position
    Date :birthday
    hstore :gimmicks
  end

  # DB.alter_table(:specimens) do
  #   add_column :firstname, String
  #   add_column :lastname, String
  # end
end

