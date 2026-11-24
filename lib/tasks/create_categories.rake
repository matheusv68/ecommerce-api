namespace :seed do
  desc "Create or update the catalogue categories"
  task categories: :environment do
    categories = [
      { name: "Eletrônicos", description: "Dispositivos e acessórios para o dia a dia." },
      { name: "Casa e Cozinha", description: "Itens funcionais para organizar e equipar a casa." },
      { name: "Moda", description: "Roupas e acessórios para uso diário." },
      { name: "Esporte e Lazer", description: "Produtos para atividades físicas e tempo livre." },
      { name: "Livros", description: "Leituras para estudo, trabalho e entretenimento." }
    ]

    categories.each do |attributes|
      category = Category.find_or_initialize_by(name: attributes[:name])
      category.assign_attributes(attributes.merge(active: true))
      category.save!
    end

    puts "#{categories.size} categories seeded"
  end
end
