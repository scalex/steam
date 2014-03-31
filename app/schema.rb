DB.transaction do
  DB.create_table?(:specimens) do
    String :nick, :size => 255, :primary_key => true
    String :foto
    String :position
    String :firstname
    String :lastname
    String :about
    Date :birthday
    json :gimmicks
    json :links
  end
end
