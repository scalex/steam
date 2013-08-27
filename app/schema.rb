DB.transaction do
  DB.extension :pg_hstore

  DB.create_table?(:specimens) do
    String :nick, :size => 255, :primary_key => true
    String :position
    Date :birthday
    hstore :gimmick
  end
end
