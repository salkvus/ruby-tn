require_relative 'interface'
require_relative 'railroad'
require_relative 'station'
require_relative 'route'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'

class Controller
  Action = Struct.new(:label, :handler, :options)

  ACTIONS = [
    Action.new('Создать станцию', :cmd_create_station, {clear_result: true}),
    Action.new('Создать поезд', :cmd_create_train, {clear_result: true}),
    Action.new('Создать маршрут', :cmd_create_route, {clear_result: true}),
    Action.new('Добавить станцию к маршруту', :cmd_add_station_to_route, {clear_result: true}),
    Action.new('Убрать станцию из маршрута', :cmd_delete_station_from_route, {clear_result: true}),
    Action.new('Назначить маршрут поезду', :cmd_assign_route_to_train, {clear_result: true}),
    Action.new('Добавить вагон к поезду', :cmd_hook_train_wagon, {}),
    Action.new('Отцепить вагон от поезда', :cmd_unhook_train_wagon, {}),
    Action.new('Переместить поезд вперед', :cmd_go_forward, {clear_result: true}),
    Action.new('Переместить поезд назад', :cmd_go_back, {clear_result: true}),
    Action.new('Показать список станций', :cmd_show_stations, {}),
    Action.new('Показать список поездов на станции', :cmd_show_trains_on_station, {}),
    Action.new('Показать список маршрутов', :cmd_show_routes, {}),
    Action.new('Показать список поездов', :cmd_show_trains, {}),
    Action.new('Выйти', :cmd_exit_menu)
  ]

  def initialize
    @interface = Interface.new
    @railroad = Railroad.new
  end

  def run
    @interface.clear
    loop do
      @interface.show_main_menu(ACTIONS)
      cmd_id = @interface.enter_number
      break if cmd_id.zero?

      action = get_action(cmd_id)
      send(action.handler)
      @interface.clear if action.options[:clear_result]
    end
  end

  private 

  def get_action(cmd_id)
    ACTIONS[cmd_id - 1]
  end

  def cmd_create_station
    @interface.prompt_station_name
    name = @interface.enter_string
    @railroad.create_station(name)
  end

  def cmd_create_route
    stations = @railroad.stations
    @interface.show_stations(stations)
    @interface.prompt_start_station
    start_station = select_from_array(stations)
    @interface.prompt_end_station
    end_station = select_from_array(stations)
    return if start_station.nil? || end_station.nil?
    return if start_station == end_station

    @railroad.create_route(start_station, end_station)
  end

  def cmd_create_train
    @interface.prompt_train_type
    train_class = select_from_array(Railroad::TRAIN_TYPES)
    @interface.prompt_train_number
    number = @interface.enter_number
    return if train_class.nil? || number.nil?

    @railroad.create_train(train_class, number)
  end

  def cmd_add_station_to_route
    @interface.show_routes(@railroad.routes)
    return if @railroad.routes.length.zero?

    @interface.prompt_route_select
    route = select_from_array(@railroad.routes)
    return if route.nil?
    
    stations = @railroad.stations.select { |station| not route.stations.include?(station)}
    return if stations.length.zero?

    @interface.show_stations(stations)
    @interface.prompt_station_add_to_route
    station = select_loop_from_array(stations)
    return if station.nil?

    @railroad.add_station_to_route(route, station)
  end

  def cmd_delete_station_from_route
    @interface.show_routes(@railroad.routes)
    return if @railroad.routes.length.zero?

    @interface.prompt_route_select
    route = select_from_array(@railroad.routes)
    return if route.nil?
    
    @interface.show_stations(route.stations)
    @interface.prompt_station_delete_from_route
    station = select_loop_from_array(route.stations)
    return if station.nil?
    
    @railroad.delete_station_from_route(route, station)
  end
  
  def cmd_assign_route_to_train
    @interface.show_routes(@railroad.routes)
    @interface.prompt_route_select
    route = select_from_array(@railroad.routes)
    return if route.nil?

    @interface.show_trains(@railroad.trains)
    @interface.prompt_train_for_assign_route
    train = select_loop_from_array(@railroad.trains)
    return if train.nil?

    @railroad.assign_route_to_train(route, train)
  end
  
  def cmd_hook_train_wagon
    @interface.show_trains(@railroad.trains)
    @interface.prompt_train_to_hook_wagon
    train = select_loop_from_array(@railroad.trains)
    return if train.nil?

    @interface.prompt_wagon_number_select
    wagon_number = @interface.enter_number
    return if wagon_number.nil?

    @railroad.hook_train_wagon(train, wagon_number)
  end

  def cmd_unhook_train_wagon
    @interface.show_trains(@railroad.trains)
    @interface.prompt_train_to_unhook_wagon
    train = select_loop_from_array(@railroad.trains)
    return if train.nil?

    @interface.prompt_wagon_number_select
    wagon_number = @interface.enter_number
    return if wagon_number.nil?

    @railroad.unhook_train_wagon(train, wagon_number)
  end

  def cmd_go_forward
    train_go_forward
  end

  def cmd_go_back
    train_go_back
  end

  def cmd_show_stations
    @interface.show_stations(@railroad.stations)
  end

  def cmd_show_trains_on_station
    @interface.show_stations(@railroad.stations)
    @interface.prompt_station_select
    station = select_loop_from_array(@railroad.stations)
    return if station.nil?

    @interface.show_trains_on_station(station)
  end

  def cmd_show_routes
    @interface.show_routes(@railroad.routes)
  end

  def cmd_show_trains
    @interface.show_trains(@railroad.trains)
  end
  
  def train_go_forward
    @interface.show_trains(@railroad.trains)
    @interface.prompt_train_select
    train = select_loop_from_array(@railroad.trains)
    return if train.nil?

    train.go_forward
  end
  
  def train_go_back
    @interface.show_trains(@railroad.trains)
    @interface.prompt_train_select
    train = select_loop_from_array(@railroad.trains)
    return if train.nil?

    train.go_back
  end

  def select_from_array(array)
    index = @interface.enter_number
    return if index.negative?

    array[index - 1]
  end

  def select_loop_from_array(array)
    loop do
      index = @interface.enter_number
      return array[index - 1] unless index.negative?
      break if @interface.check_operation_cancel
    end
  end
end

Controller.new.run

