require "digest"

namespace :seed do
  desc "Create or update the catalogue products"
  task products: :environment do
    categories = Category.all.index_by(&:name)
    image_path = Rails.root.join("db/seeds/images/product.jpeg")

    raise "Seed image not found: #{image_path}" unless image_path.file?

    image_checksum = Digest::MD5.base64digest(File.binread(image_path))
    image_blob = ActiveStorage::Blob.find_by(
      filename: image_path.basename.to_s,
      checksum: image_checksum
    )

    unless image_blob
      image_blob = File.open(image_path) do |file|
        ActiveStorage::Blob.create_and_upload!(
          io: file,
          filename: image_path.basename.to_s,
          content_type: "image/jpeg"
        )
      end
    end

    # Decisão do MVP: produtos usam Active Storage. Esta imagem de demonstração
    # é compartilhada pelos produtos para manter o seed reproduzível.
    products = [
      {
        category_name: "Eletrônicos",
        name: "Fone de Ouvido Bluetooth",
        description: "Fone sem fio com microfone integrado e estojo de recarga.",
        price_cents: 12_990,
        stock_quantity: 24,
        sku: "ELEC-FONE-001"
      },
      {
        category_name: "Eletrônicos",
        name: "Teclado Mecânico Compacto",
        description: "Teclado compacto com conexão USB e teclas de perfil baixo.",
        price_cents: 18_990,
        stock_quantity: 15,
        sku: "ELEC-TECL-001"
      },
      {
        category_name: "Eletrônicos",
        name: "Mouse Sem Fio",
        description: "Mouse ergonômico com receptor USB e ajuste de sensibilidade.",
        price_cents: 7_490,
        stock_quantity: 32,
        sku: "ELEC-MOUSE-001"
      },
      {
        category_name: "Eletrônicos",
        name: "Carregador USB-C 30W",
        description: "Carregador de tomada compacto com porta USB-C e carregamento rápido.",
        price_cents: 8_990,
        stock_quantity: 28,
        sku: "ELEC-CARR-001"
      },
      {
        category_name: "Eletrônicos",
        name: "Suporte Ajustável para Notebook",
        description: "Suporte de alumínio com altura regulável para mesas de trabalho.",
        price_cents: 10_990,
        stock_quantity: 18,
        sku: "ELEC-SUPN-001"
      },
      {
        category_name: "Eletrônicos",
        name: "Caixa de Som Portátil",
        description: "Caixa de som Bluetooth resistente a respingos para ambientes internos.",
        price_cents: 15_990,
        stock_quantity: 20,
        sku: "ELEC-SOM-001"
      },
      {
        category_name: "Casa e Cozinha",
        name: "Garrafa Térmica 500 ml",
        description: "Garrafa de aço inoxidável que conserva bebidas quentes ou frias.",
        price_cents: 6_990,
        stock_quantity: 40,
        sku: "CASA-GARR-001"
      },
      {
        category_name: "Casa e Cozinha",
        name: "Jogo de Potes Herméticos",
        description: "Conjunto com cinco potes para armazenamento de alimentos.",
        price_cents: 9_990,
        stock_quantity: 22,
        sku: "CASA-POTE-001"
      },
      {
        category_name: "Casa e Cozinha",
        name: "Organizador de Gavetas",
        description: "Kit modular para organizar utensílios e pequenos objetos.",
        price_cents: 5_490,
        stock_quantity: 35,
        sku: "CASA-ORGA-001"
      },
      {
        category_name: "Casa e Cozinha",
        name: "Frigideira Antiaderente 24 cm",
        description: "Frigideira com revestimento antiaderente e cabo resistente ao calor.",
        price_cents: 11_990,
        stock_quantity: 16,
        sku: "CASA-FRIG-001"
      },
      {
        category_name: "Casa e Cozinha",
        name: "Luminária de Mesa LED",
        description: "Luminária com três níveis de intensidade e braço articulado.",
        price_cents: 9_490,
        stock_quantity: 19,
        sku: "CASA-LUMI-001"
      },
      {
        category_name: "Casa e Cozinha",
        name: "Tapete de Banheiro Antiderrapante",
        description: "Tapete macio e lavável com base aderente.",
        price_cents: 4_990,
        stock_quantity: 30,
        sku: "CASA-TAPE-001"
      },
      {
        category_name: "Moda",
        name: "Camiseta Básica de Algodão",
        description: "Camiseta de modelagem regular para uso diário.",
        price_cents: 5_990,
        stock_quantity: 45,
        sku: "MODA-CAMI-001"
      },
      {
        category_name: "Moda",
        name: "Moletom com Capuz",
        description: "Moletom confortável com bolso frontal e capuz ajustável.",
        price_cents: 15_990,
        stock_quantity: 21,
        sku: "MODA-MOLE-001"
      },
      {
        category_name: "Moda",
        name: "Calça Jeans Reta",
        description: "Calça jeans de lavagem escura e corte reto.",
        price_cents: 17_990,
        stock_quantity: 17,
        sku: "MODA-CALC-001"
      },
      {
        category_name: "Moda",
        name: "Tênis Casual",
        description: "Tênis de cano baixo com sola de borracha e cadarço.",
        price_cents: 21_990,
        stock_quantity: 14,
        sku: "MODA-TENI-001"
      },
      {
        category_name: "Moda",
        name: "Boné Aba Curva",
        description: "Boné ajustável com tecido leve e aba curva.",
        price_cents: 6_490,
        stock_quantity: 26,
        sku: "MODA-BONE-001"
      },
      {
        category_name: "Moda",
        name: "Bolsa Transversal",
        description: "Bolsa compacta com alça regulável e compartimento interno.",
        price_cents: 12_490,
        stock_quantity: 18,
        sku: "MODA-BOLS-001"
      },
      {
        category_name: "Esporte e Lazer",
        name: "Tapete de Yoga",
        description: "Tapete antiderrapante para exercícios, alongamento e yoga.",
        price_cents: 8_990,
        stock_quantity: 25,
        sku: "ESP-YOGA-001"
      },
      {
        category_name: "Esporte e Lazer",
        name: "Corda de Pular Ajustável",
        description: "Corda leve com comprimento ajustável e pegadores confortáveis.",
        price_cents: 3_990,
        stock_quantity: 50,
        sku: "ESP-CORD-001"
      },
      {
        category_name: "Esporte e Lazer",
        name: "Bola de Futebol",
        description: "Bola costurada à máquina para treinos recreativos.",
        price_cents: 7_990,
        stock_quantity: 23,
        sku: "ESP-BOLA-001"
      },
      {
        category_name: "Esporte e Lazer",
        name: "Garrafa Esportiva 750 ml",
        description: "Garrafa leve com tampa de abertura rápida para hidratação.",
        price_cents: 3_490,
        stock_quantity: 38,
        sku: "ESP-GARR-001"
      },
      {
        category_name: "Esporte e Lazer",
        name: "Elástico de Resistência",
        description: "Faixa elástica de resistência média para treinos funcionais.",
        price_cents: 4_490,
        stock_quantity: 34,
        sku: "ESP-ELAS-001"
      },
      {
        category_name: "Esporte e Lazer",
        name: "Mochila para Academia",
        description: "Mochila com compartimento para roupas e bolso para garrafa.",
        price_cents: 13_990,
        stock_quantity: 16,
        sku: "ESP-MOCH-001"
      },
      {
        category_name: "Livros",
        name: "Clean Code",
        description: "Livro sobre práticas de escrita e manutenção de código.",
        price_cents: 12_990,
        stock_quantity: 12,
        sku: "LIV-CODE-001"
      },
      {
        category_name: "Livros",
        name: "O Programador Pragmático",
        description: "Guia prático sobre desenvolvimento de software e carreira.",
        price_cents: 13_990,
        stock_quantity: 11,
        sku: "LIV-PRAG-001"
      },
      {
        category_name: "Livros",
        name: "Design de APIs",
        description: "Introdução a decisões de design para APIs web.",
        price_cents: 10_990,
        stock_quantity: 20,
        sku: "LIV-API-001"
      },
      {
        category_name: "Livros",
        name: "Hábitos Atômicos",
        description: "Livro sobre construção de hábitos por meio de pequenas mudanças.",
        price_cents: 9_990,
        stock_quantity: 27,
        sku: "LIV-HABI-001"
      },
      {
        category_name: "Livros",
        name: "Essencialismo",
        description: "Leitura sobre foco e escolhas conscientes no dia a dia.",
        price_cents: 8_990,
        stock_quantity: 24,
        sku: "LIV-ESSE-001"
      },
      {
        category_name: "Livros",
        name: "A Psicologia Financeira",
        description: "Livro sobre comportamento, decisões e dinheiro.",
        price_cents: 11_490,
        stock_quantity: 19,
        sku: "LIV-PSFI-001"
      }
    ]

    products.each do |attributes|
      category_name = attributes.delete(:category_name)
      category = categories.fetch(category_name)

      product = Product.find_or_initialize_by(sku: attributes[:sku])
      product.assign_attributes(attributes.merge(category: category, active: true))
      product.save!

      image_is_current = product.image.attached? && product.image.blob.id == image_blob.id
      product.image.attach(image_blob) unless image_is_current
    end

    puts "#{products.size} products seeded"
  end
end
