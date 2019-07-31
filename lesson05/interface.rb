
class Interface
  
  def prompt_station_name
    print 'Введите название станции: '
  end

  def prompt_station_select
    print "Введите станцию: "
  end

  def prompt_start_station
    print 'Выберите начальную станцию: '
  end

  def prompt_end_station
    print 'Выберите конечную станцию: '
  end
  
  def prompt_station_add_to_route
    print 'Выберите станцию для добавления к маршруту: '
  end

  def prompt_station_delete_from_route
    print 'Выберите станцию для удаления из маршрута: '
  end

  def prompt_train_type
    print 'Выберите тип поезда [1 - пассажирский, 2 - грузовой]: '
  end

  def prompt_train_number
    print 'Введите номер поезда: '
  end

  def prompt_train_select
    print 'Выберите поезд: '
  end

  def prompt_train_for_assign_route
    print 'Выберите поезд для назначения маршрута: '
  end

  def prompt_train_to_hook_wagon
    print 'Выберите поезд для добавления вагона: '
  end

  def prompt_train_to_unhook_wagon
    print "Выберите поезд, для отцепления вагона: "
  end

  def prompt_wagon_number_select
    print 'Введите номер вагона: '
  end

  def prompt_route_select
    print 'Выберите маршрут: '
  end

  def check_route_cancel
    print "Отменить создание маршрута [y/n]: "
    check_yes_answer
  end

  def check_operation_cancel
    print "Отменить операцию [y/n]: "
    check_yes_answer
  end

  def check_yes_answer
    gets.chomp.downcase == "y"
  end

  def enter_string
    gets.chomp
  end

  def enter_number
    gets.to_i
  end
    
  def show_routes(railroad)
    return puts "Маршрутов не найдено" if railroad.routes.length.zero?

    railroad.routes.each.with_index do |route, index|
      puts "Маршрут " + (index + 1).to_s
      route.show
    end
  end
  
  def show_stations(railroad)
    return puts "Станций не найдено" if railroad.stations.length.zero?

    puts "Станции:"
    puts railroad.stations.map.with_index { |station, index| (index + 1).to_s.rjust(4) + " - " + station.name }
  end

  def show_trains_on_station(station)
    return puts "На станции #{station.name} нет поездов" if station.trains.length.zero?

    puts "Поезда на станции #{station.name}:"
    station.trains.each.with_index do |train, index|
      show_train(train, index + 1)
    end
  end

  def show_trains(railroad)
    return puts "Поездов не найдено" if railroad.trains.length.zero?

    puts "Поезда:"
    railroad.trains.map.with_index do |train, index|
      show_train(train, index + 1)
    end
  end

  def show_train_wagons(train)
    train.wagons.each { |wagon| puts "Вагон - #{wagon.number}".rjust(12)}
  end

  private

  def show_train(train, index)
    puts index.to_s.rjust(2) + " - Номер поезда: #{train.number}, тип: #{train.type}, маршрут: "
    train.route.show unless train.route.nil?
    show_train_wagons(train) unless train.wagons.length.zero?
  end
end
