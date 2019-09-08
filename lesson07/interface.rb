
class Interface

  def show_main_menu(actions)
    actions.each.with_index(1) do |item, index|
      if index == actions.length
        puts "0. #{item.label}"
      else
        puts "#{index}. #{item.label}"
      end
    end
    print 'Выберите номер операции: '
  end

  def clear
    system('clear')
  end

  def prompt_retry_command(label)
    print "Выполнить команду \"#{label}\" повторно? (y/n):"
  end

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
    
  def show_routes(routes)
    return puts("Маршрутов не найдено") if routes.length.zero?

    routes.each.with_index(1) do |route, index|
      puts "Маршрут " + index.to_s
      route.show
    end
  end
  
  def show_stations(stations)
    return puts("Станций не найдено") if stations.length.zero?

    puts "Станции:"
    puts stations.map.with_index(1) { |station, index| index.to_s.rjust(4) + " - " + station.name }
  end

  def show_station(station)
    puts station.name
  end

  def show_trains_on_station(station)
    return puts("На станции #{station.name} нет поездов".rjust(4)) if station.trains.length.zero?

    puts "Поезда на станции #{station.name}:".rjust(4)
    station.trains.each.with_index(1) do |train, index|
      show_train(train, index)
    end
  end

  def show_trains(trains)
    return puts("Поездов не найдено") if trains.length.zero?

    puts "Поезда:"
    trains.map.with_index(1) do |train, index|
      show_train(train, index)
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
