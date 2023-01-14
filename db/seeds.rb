# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

users = User.create!([
  {
    name: 'Obi-Wan Kenobi',
    email: 'obiwan@jedi.com',
    password: 'obiwan',
  },
  {
    name: 'Asoka Kai',
    email: 'asoka@jedi.com',
    password: 'obiwan',
  },
  {
    name: 'Abel G',
    email: 'abel@gmail.com',
    password: '123456',
  },
  {
    name: 'Aamir Khan',
    email: 'aamir@khan.com',
    password: '123456',
  },
  {
    name: 'Milen',
    email: 'milen@gmail.com',
    password: '123456',
  },
])

cars = Car.create!([
  {
    user_id: 1,
    name: 'Range Rover',
    image: 'https://www.topgear.com/sites/default/files/2021/10/RR_22MY_10_Exterior_261021_EXT_054.jpg?w=1784&h=1004',
    model: '2021',
    daily_price: 200,
    description: 'The Range Rover is a full-size luxury SUV produced by British car maker Land Rover, a marque of Jaguar Land Rover. The Range Rover is the flagship model of the marque, and has been in continuous production since 1970.'
  },
  {
    user_id: 2,
    name: 'Rivian R1T',
    image: 'https://www.cnet.com/a/img/resize/03e9f19c83795820d5fac35dee68433c37f237cc/hub/2021/11/10/5861d875-293a-495c-9e95-72c9d5fbb999/rivian-r1t-slow-deliveries-promo-image.jpg?auto=webp&fit=crop&height=675&width=1200',
    model: '2021',
    daily_price: 200,
    description: 'The Rivian R1T is an all-electric pickup truck that is being developed by Rivian Automotive. The R1T is Rivian’s first vehicle, and is expected to be released in 2021.'
  },
  {
    user_id: 3,
    name: 'BMW 3 Series',
    image: 'https://hips.hearstapps.com/hmg-prod/images/2021-bmw-3-series-mmp-1-1593549868.jpg',
    model: '2021',
    daily_price: 150,
    description: 'The BMW 3 Series is a compact executive car manufactured by the German automaker BMW since May 1975. It is the successor to the 02 Series and has been produced in six different generations.'
  },
  {
    user_id: 4,
    name: 'Audi A4',
    image: 'https://images.livemint.com/img/2021/01/05/1600x900/Audi1_1609834939606_1609834946676.jpg',
    model: '2021',
    daily_price: 100,
    description: 'The Audi A4 is a line of compact executive cars produced since 1994 by the German car manufacturer Audi, a subsidiary of the Volkswagen Group. The A4 has been built in five generations and is based on the Volkswagen Group B platform.'
  },
  {
    user_id: 5,
    name: 'Tesla Model X',
    image: 'https://www.tesla.com/sites/default/files/modelsx-new/social/model-x-social.jpg',
    model: '2021',
    daily_price: 200,
    description: 'The Tesla Model X is a mid-size all-electric luxury crossover SUV made by Tesla, Inc. It is the first vehicle in Tesla\'s lineup to be built on the company\'s third-generation platform, which is shared with the Model S and Model 3.'
  },
  {
    user_id: 1,
    name: 'Ford F-Series',
    image: 'https://i.gaw.to/vehicles/photos/40/29/402947-2022-ford-f-150.jpg',
    model: '2022',
    daily_price: 100,
    description: 'The Ford F-Series is a series of light-duty trucks and medium-duty trucks (Class 2-7) that have been marketed and manufactured by Ford Motor Company since 1948. While most variants of the F-Series trucks are full-size pickup trucks, the F-Series also includes chassis cab trucks and commercial vehicles.'
  },
  {
    user_id: 2,
    name: 'Ferrari 812',
    image: 'https://www.motortrend.com/uploads/sites/5/2021/05/2021-Ferrari-812-GTS-55.jpg',
    model: '2021',
    daily_price: 1000,
    description: 'The Ferrari 812 Superfast is a front mid-engine, rear-wheel-drive grand tourer produced by Ferrari. It is the successor to the Ferrari F12berlinetta and was unveiled at the 2017 Geneva Motor Show.'
  },
  {
    user_id: 3,
    name: 'Porsche 911',
    image: 'https://i.gaw.to/vehicles/photos/40/25/402523-2021-porsche-911.jpg',
    model: '2021',
    daily_price: 200,
    description: 'The Porsche 911 is a two-door, 2+2 high performance rear-engined sports car made since 1963 by Porsche AG of Stuttgart, Germany. It has a rear-mounted flat-six engine and all round independent suspension.'
  },
  {
    user_id: 4,
    name: 'Lexus UX',
    image: 'https://media.ed.edmunds-media.com/lexus/ux-200/2019/oem/2019_lexus_ux-200_4dr-suv_base_fq_oem_1_1600.jpg',
    model: '2021',
    daily_price: 100,
    description: 'The Lexus UX is a subcompact luxury crossover SUV manufactured by Toyota\'s luxury brand Lexus. It is the smallest SUV in the Lexus lineup, slotting below the Lexus NX. The UX was unveiled at the 2018 Beijing Auto Show.'
  },
  {
    user_id: 5,
    name: 'Pagani Huayara',
    image: 'https://cdn.carbuzz.com/gallery-images/1600/611000/700/611762.jpg',
    model: '2021',
    daily_price: 1000,
    description: 'The Pagani Huayra is a mid-engined sports car produced by Italian automotive manufacturer Pagani. The Huayra was first shown at the 2011 Geneva Motor Show and was officially unveiled at the 2012 Geneva Motor Show.'
  },
  {
    user_id: 1,
    name: 'Maserati Ghibli',
    image: 'https://www.cnet.com/a/img/resize/d792ba1221fd2a1a4496484421c83aba6d4af826/hub/2021/05/18/15e5d293-dfdb-465c-8137-f9e8d3517591/2021-maserati-ghibli-trofeo-014.jpg?auto=webp&width=1200',
    model: '2021',
    daily_price: 200,
    description: 'The Maserati Ghibli is a mid-size luxury sports sedan produced by Italian automobile manufacturer Maserati. The Ghibli is the first Maserati to be available with all-wheel drive and the first to be available with a diesel engine.'
  },
  {
    user_id: 2,
    name: 'Lamborghini Aventador',
    image: 'https://i.ytimg.com/vi/qft8lwmQzns/maxresdefault.jpg',
    model: '2021',
    daily_price: 1000,
    description: 'The Lamborghini Aventador is a mid-engined sports car produced by the Italian automotive manufacturer Lamborghini. The Aventador is the successor to the long-running Lamborghini Murciélago.'
  },
  {
    user_id: 3,
    name: 'Bugatti Chiron',
    image: 'https://cdn.motor1.com/images/mgl/nGzgl/s1/2021-bugatti-chiron-front.jpg',
    model: '2021',
    daily_price: 1000,
    description: 'The Bugatti Chiron is a mid-engined two-seated sports car developed and manufactured in Molsheim, France, by Bugatti Automobiles S.A.S. as the successor to the Bugatti Veyron.'
  },
  {
    user_id: 4,
    name: 'Rolls-Royce Phantom',
    image: 'https://www.simplycarbuyers.com/blog/wp-content/uploads/2021/05/Rolls-Royce-Phantom-2021.jpg',
    model: '2021',
    daily_price: 1000,
    description: 'The Rolls-Royce Phantom is a British luxury saloon manufactured by Rolls-Royce Motor Cars. The Phantom is the flagship model of Rolls-Royce and has been in continuous production for more than 90 years.'
  },
  {
    user_id: 5,
    name: 'Bentley Continental',
    image: 'https://i.pinimg.com/originals/e4/f8/19/e4f819a60c04fd00d5e833948f9a1e04.jpg',
    model: '2021',
    daily_price: 1000,
    description: 'The Bentley Continental GT is a grand tourer produced by British automaker Bentley Motors since 2003. It is the first car released by Bentley under Volkswagen AG management, after the company\'s acquisition of the British automaker in 1998.'
  },
  {
    user_id: 1,
    name: 'Aston Martin DB11 ',
    image: 'https://hips.hearstapps.com/hmg-prod/images/2018-aston-martin-db11-amr-156-1525983030.jpg?crop=0.668xw:0.615xh;0.115xw,0.272xh&resize=1200:*',
    model: '2021',
    daily_price: 1000,
    description: 'The Aston Martin DB11 is a grand tourer manufactured by British luxury car manufacturer Aston Martin. The DB11 is the successor to the DB9 and was unveiled at the 2016 Geneva Motor Show.'
  },
  {
    user_id: 2,
    name: 'Cadillac XT6',
    image: 'https://hips.hearstapps.com/hmg-prod/images/2021-cadillac-xt6-mmp-1-1594071555.jpg?crop=0.728xw:0.546xh;0.236xw,0.255xh&resize=1200:*',
    model: '2021',
    daily_price: 1000,
    description: 'The Cadillac XT6 is a mid-size luxury crossover SUV manufactured by General Motors. It is the first three-row crossover SUV from Cadillac, and is based on the GM Lambda platform.'
  },
  {
    user_id: 3,
    name: 'Chevrolet Corvette',
    image: 'https://cdn.motor1.com/images/mgl/OOEoX/s3/2020-chevrolet-corvette-first-drive.jpg',
    model: '2021',
    daily_price: 1000,
    description: 'The Chevrolet Corvette, known colloquially as the Vette or Chevy Corvette, is a front engine, rear drive, two-door, two-passenger sports car manufactured and marketed by Chevrolet across more than sixty years of production and seven design generations.'
  },
  {
    user_id: 4,
    name: 'Chrysler 300',
    image: 'https://media.ed.edmunds-media.com/chrysler/300/2021/oem/2021_chrysler_300_sedan_s_fq_oem_1_1600.jpg',
    model: '2021',
    daily_price: 1000,
    description: 'The Chrysler 300 is a full-size luxury sedan manufactured by FCA US LLC (formerly Chrysler Group LLC), a subsidiary of Fiat Chrysler Automobiles. It was introduced at the 2003 North American International Auto Show for the 2005 model year.'
  },
  {
    user_id: 5,
    name: 'Dodge Challenger',
    image: 'https://www.thedrive.com/content/2020/08/DG020_165CLvbd9cautcph0ndplqpurf31pcr.jpg',
    model: '2021',
    daily_price: 1000,
    description: 'The Dodge Challenger is the name of three different generations of automobiles (two of those being pony cars) produced by American automobile manufacturer Dodge. However, the first use of the Challenger name by Dodge was in 1959 for marketing a "value version" of the full-sized Coronet Silver Challenger.'
  },
  {
    user_id: 1,
    name: 'Alfa Romeo Stelvio',
    image: 'https://di-uploads-pod5.dealerinspire.com/arrigoalfaromeoofwestpalm/uploads/2021/08/2021-alfa-romeo-stelvio-in-west-palm-beach.png',
    model: '2021',
    daily_price: 1000,
    description: 'The Alfa Romeo Stelvio is a compact luxury crossover SUV manufactured by Italian automaker Alfa Romeo. The Stelvio is Alfa Romeo\'s first SUV and is based on the Giorgio platform, which underpins the Alfa Romeo Giulia.'
  },
  {
    user_id: 2,
    name: 'McLaren 720S',
    image: 'https://cdn.carbuzz.com/gallery-images/1600/543000/500/543544.jpg',
    model: '2021',
    daily_price: 1000,
    description: 'The McLaren 720S is a British sports car produced by McLaren Automotive. The 720S is the second model in the Super Series, sitting below the McLaren P1 and above the McLaren 570S.'
  },
  {
    user_id: 3,
    name: 'Mercedes-Benz',
    image: 'https://media.ed.edmunds-media.com/mercedes-benz/gls-class/2021/oem/2021_mercedes-benz_gls-class_4dr-suv_amg-gls-63_fq_oem_1_1600.jpg',
    model: '2021',
    daily_price: 1000,
    description: 'The Mercedes-Benz GLS-Class is a full-size luxury SUV produced by the German automaker Mercedes-Benz since 2006. The first generation (X164) was launched in 2006 as the successor to the Mercedes-Benz GL-Class (X164).'
  }
])
