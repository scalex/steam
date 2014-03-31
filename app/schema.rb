DB.transaction do
  DB.extension :pg_hstore

  DB.create_table?(:specimens) do
    String :nick, :size => 255, :primary_key => true
    String :position
    String :firstname
    String :lastname
    String :about
    Date :birthday
    json :gimmicks
    json :links
  end
end

