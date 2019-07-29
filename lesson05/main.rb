require_relative 'station'
require_relative 'route'
require_relative 'train_pass'
require_relative 'train_cargo'
require_relative 'wagon_pass'
require_relative 'wagon_cargo'

class Railroad
  attr_accessor :stations, :trains, :routes, :wagons

  def initialize
    @stations = []
    @trains = []
    @routes = []
    @wagons = []
  end

  def show_stations
    return puts "Станций не найдено" if stations.length.zero?

    puts "Станции:"
    puts stations.map.with_index { |station, index| index.to_s.rjust(4) + " - " + station.name }
  end

  def show_trains_on_station(station)
    return puts "На станции #{station.name} нет поездов" if station.trains.length.zero?

    puts "Поезда на станции #{station.name}:"
    station.trains.each.with_index do |train, index|
      show_train(train, index)
    end
  end

  def show_routes
    return puts "Маршрутов не найдено" if routes.length.zero?

    routes.each.with_index do |route, index|
      puts "Маршрут " + index.to_s
      route.show
    end
  end

  def show_trains
    return puts "Поездов не найдено" if trains.length.zero?

    puts "Поезда:"
    trains.map.with_index do |train, index|
      show_train(train, index)
    end
  end

  def show_train_wagons(train)
    train.wagons.each { |wagon| puts "Вагон - #{wagon.number}".rjust(12)}
  end

  private

  def show_train(train, index)
    puts index.to_s.rjust(2) + " - Номер поезда: #{train.number}, маршрут: "
    train.route.show unless train.route.nil?
    show_train_wagons(train)
  end
end

class Menu

  def initialize

    @commands = {
      1 => [:cmd_create_station, 'Создать станцию'],
      2 => [:cmd_create_train, 'Создать поезд'],
      3 => [:cmd_create_route, 'Создать маршрут'],
      4 => [:cmd_add_station_to_route, 'Добавить станцию к маршруту'],
      5 => [:cmd_delete_station_from_route, 'Убрать странцию из маршрута'],
      6 => [:cmd_assign_route_to_train, 'Назначить маршрут поезду'],
      7 => [:cmd_hook_train_wagon, 'Добавить вагон к поезду'],
      8 => [:cmd_unhook_train_wagon, 'Отцепить вагон от поезда'],
      9 => [:cmd_go_forward, 'Переместить поезд вперед'],
      10 => [:cmd_go_back, 'Переместить поезд назад'],
      11 => [:cmd_show_stations, 'Показать список станций'],
      12 => [:cmd_show_trains_on_station, 'Показать список поездов на станции'],
      13 => [:cmd_show_routes, 'Показать список маршрутов'],
      14 => [:cmd_show_trains, 'Показать список поездов'],
      0 => [:cmd_exit_menu, 'Выйти']
    }

  end

  def execute_command(id)
    self.send(@commands[id][0])
  end

  def cmd_create_station
    print 'Введите название станции: '
    name = gets.chomp
    $railroad.stations << Station.new(name) unless name.empty?
  end

  def cmd_create_route
    start_station = nil
    end_station = nil
    loop do
      if start_station.nil?
        $railroad.show_stations
        print 'Выберите начальную станцию: '
        station_id = gets.to_i
        start_station = $railroad.stations[station_id] unless station_id.nil?
      end
      if end_station.nil?
        print 'Выберите конечную станцию: '
        station_id = gets.to_i
        end_station = $railroad.stations[station_id] unless station_id.nil?
      end
      break unless start_station.nil? || end_station.nil?
      print "Отменить создание маршрута [y/n]: "
      break if gets.chomp.downcase == "y"
    end
    unless start_station.nil? && end_station.nil?
      $railroad.routes << Route.new(start_station, end_station)
    end
  end

  def cmd_create_train
    print 'Выберите тип поезда [1 - пассажирский, 2 - грузовой]: '
    type_id = gets.to_i
    print 'Введите номер поезда: '
    number = gets.chomp
    unless type_id.nil? || number.nil?
      $railroad.trains << if type_id == 1
                            PassengerTrain.new(number)
                          else
                            CarogoTrain.new(number)
                          end
    else
      puts "Поезд не создан: недостаточно введено данных"
    end
  end

  def cmd_add_station_to_route
    $railroad.show_routes
    print 'Выберите маршрут: '
    route_id = gets.to_i
    route = $railroad.routes[route_id] unless route_id.nil?
    return if route.nil?
    
    station = nil
    $railroad.show_stations
    print 'Выберите станцию, чтобы добавить к маршруту: '
    loop do
      if station.nil?
        station_id = gets.to_i
        station = $railroad.stations[station_id] unless station_id.nil?
      end
      break unless station.nil?
      print "Отменить добавление станции к маршруту [y/n]: "
      break if gets.chomp.downcase == "y"
    end
    route.add(station) unless route.stations.include?(station)
  end

  def cmd_delete_station_from_route
    $railroad.show_routes
    print 'Выберите маршрут: '
    route_id = gets.to_i
    route = $railroad.routes[route_id] unless route_id.nil?
    return if route.nil?
    
    station = nil
    route.show
    print 'Выберите станцию для удаления из маршрута: '
    loop do
      if station.nil?
        station_id = gets.to_i
        station = route.stations[station_id] unless station_id.nil?
      end
      break unless station.nil?
      print "Отменить удаление станции из маршрута [y/n]: "
      break if gets.chomp.downcase == "y"
    end
    route.stations.delete(station) if route.stations.include?(station)
  end
  
  def cmd_assign_route_to_train
    $railroad.show_routes
    print 'Выберите маршрут: '
    route_id = gets.to_i
    route = $railroad.routes[route_id] unless route_id.nil?
    return if route.nil?
    
    train = nil
    $railroad.show_trains
    print 'Выберите поезд для назначения маршрута: '
    loop do
      if train.nil?
        train_id = gets.to_i
        train = $railroad.trains[train_id] unless train_id.nil?
      end
      break unless train.nil?
      print "Отменить назначение маршрута для поезда [y/n]: "
      break if gets.chomp.downcase == "y"
    end
    train.route = route unless train.nil?
  end
  
  def cmd_hook_train_wagon
    wagon = nil
    train = nil
    $railroad.show_trains
    print "Выберите поезд для добавления вагона: "
    train_id = gets.to_i
    train = $railroad.trains[train_id] unless train_id.nil?
    unless train.nil?
      print 'Введите номер вагона: '
      number = gets.to_i
      unless number.nil?
        if train.is_a?(PassengerTrain)
          wagon = PassengerWagon.new(number)
        else
          wagon = CargoWagon.new(number)
        end
        train.hook_wagon(wagon) unless train.nil? || wagon.nil?
      end
    end
  end

  def cmd_unhook_train_wagon
    wagon = nil
    train = nil
    $railroad.show_trains
    print "Выберите поезд, для отцепления вагона: "
    train_id = gets.to_i
    train = $railroad.trains[train_id] unless train_id.nil?
    unless train.nil?
      $railroad.show_train_wagons(train)
      print 'Введите номер вагона: '
      number = gets.to_i
      train.unhook_wagon_by_number(number) unless train.nil? || number.nil?
    end
  end

  def cmd_go_forward
    go_train(:go_forward)
  end

  def cmd_go_back
    go_train(:go_back)
  end

  def cmd_show_stations
    $railroad.show_stations
  end

  def cmd_show_trains_on_station
    station = nil
    $railroad.show_stations
    print 'Выберите станцию: '
    loop do
      if station.nil?
        station_id = gets.to_i
        station = $railroad.stations[station_id] unless station_id.nil?
      end
      break unless station.nil?
      print "Отменить операцию [y/n]: "
      break if gets.chomp.downcase == "y"
    end
    $railroad.show_trains_on_station(station) unless station.nil?
  end

  def cmd_show_routes
    $railroad.show_routes
  end

  def cmd_show_trains
    $railroad.show_trains
  end

  def show_menu
    @commands.each { |number, choice| puts "#{number}. #{choice[1]}" }
    print 'Выберите номер операции: '
  end

  private
  
  def go_train(direction)
    if direction == :go_forward
      direction_str = "вперед"
    elsif direction == :go_back
      direction_str = "назад"
    else
      raise ArgumentError, "Указан неверный параметр direction #{direction_str}"
    end
    train = nil
    $railroad.show_trains
    print "Выберите поезд для перемещения #{direction_str} по маршруту: "
    loop do
      if train.nil?
        train_id = gets.to_i
        train = $railroad.trains[train_id] unless train_id.nil?
      end
      break unless train.nil?
      print "Отменить движение для поезда [y/n]: "
      break if gets.chomp.downcase == "y"
    end
    train.send(direction) unless train.nil?
  end
end

$railroad = Railroad.new

menu = Menu.new
system('clear')
loop do
  menu.show_menu
  choice = gets.to_i
  break if choice.zero?
  menu.execute_command(choice)
  if [11, 12, 13, 14].include?(choice)
    puts
  else
    system('clear')
  end
end
