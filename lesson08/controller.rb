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
    Action.new('Занять место в вагоне', :cmd_occupy_seat_in_wagon, {clear_result: true}),
    Action.new('Освободить место в вагоне', :cmd_free_seat_in_wagon, {clear_result: true}),
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
      @interface.clear if action.options[:clear_result]
      send(action.handler)
    end
  end

  private
  
  def get_action(cmd_id)
    ACTIONS[cmd_id - 1]
  end

  def cmd_create_station
    loop do
      @interface.prompt_station_name
      name = @interface.enter_string
      begin
        @railroad.create_station(name)
        break
      rescue StandardError => e
        puts e.message
        @interface.prompt_retry_command("Создать станцию")
        answer = @interface.enter_string
        break unless answer.empty? or answer == "y"
        @interface.clear
      end
    end
  end

  def cmd_create_route
    loop do
      stations = @railroad.stations
      @interface.show_stations(stations)
      @interface.prompt_start_station
      start_station = select_from_array(stations)
      @interface.prompt_end_station
      end_station = select_from_array(stations)

      begin
        @railroad.create_route(start_station, end_station)
        break
      rescue StandardError => e
        puts e.message
        @interface.prompt_retry_command("Создать маршрут")
        answer = @interface.enter_string
        break unless answer.empty? or answer == "y"
        @interface.clear
      end
    end
  end

  def cmd_create_train
    loop do
      @interface.prompt_train_type
      train_class = select_from_array(Railroad::TRAIN_TYPES)
      @interface.prompt_train_number
      train_number = @interface.enter_string

      begin
        @railroad.create_train(train_class, train_number)
        break
      rescue StandardError => e
        puts e.message
        @interface.prompt_retry_command("Создать поезд")
        answer = @interface.enter_string
        break unless answer.empty? or answer == "y"
        @interface.clear
      end
    end
  end

  def cmd_add_station_to_route
    loop do
      @interface.show_routes(@railroad.routes)
      return if @railroad.routes.length.zero?

      begin
        @interface.prompt_route_select
        route = select_from_array(@railroad.routes)
        raise StandardError.new("Adding station for route error: route is not selected") if route.nil?
        
        stations = @railroad.stations.select { |station| not route.stations.include?(station)}
        raise StandardError.new("Adding station for route error: no stations to add") if stations.length.zero?

        @interface.show_stations(stations)
        @interface.prompt_station_add_to_route
        station = select_loop_from_array(stations)
        raise StandardError.new("Adding station for route error: station is not selected") if station.nil?

        @railroad.add_station_to_route(route, station)
        break
      rescue StandardError => e
        puts e.message
        @interface.prompt_retry_command("Добавить станцию к маршруту")
        answer = @interface.enter_string
        break unless answer.empty? or answer == "y"
        @interface.clear
      end
    end
  end

  def cmd_delete_station_from_route
    loop do
      begin
        @interface.show_routes(@railroad.routes)
        raise StandardError.new("Deleting station from route error: no any routes") if @railroad.routes.length.zero?

        @interface.prompt_route_select
        route = select_from_array(@railroad.routes)
        raise StandardError.new("Deleting station from route error: route is not selected") if route.nil?
        
        @interface.show_stations(route.stations)
        @interface.prompt_station_delete_from_route
        station = select_loop_from_array(route.stations)
        raise StandardError.new("Deleting station from route error: station is not selected") if station.nil?
        
        @railroad.delete_station_from_route(route, station)
        break
      rescue StandardError => e
        puts e.message
        @interface.prompt_retry_command("Убрать станцию из маршрута")
        answer = @interface.enter_string
        break unless answer.empty? or answer == "y"
        @interface.clear
      end
    end
  end
  
  def cmd_assign_route_to_train
    loop do
      begin
        @interface.show_routes(@railroad.routes)
        @interface.prompt_route_select
        route = select_from_array(@railroad.routes)
        raise StandardError.new("Assigning route to train error: route is not selected") if route.nil?

        @interface.show_trains(@railroad.trains)
        @interface.prompt_train_for_assign_route
        train = select_loop_from_array(@railroad.trains)
        raise StandardError.new("Assigning route to train error: train is not selected") if train.nil?

        @railroad.assign_route_to_train(route, train)
        break
      rescue StandardError => e
        puts e.message
        @interface.prompt_retry_command("Назначить маршрут поезду")
        answer = @interface.enter_string
        break unless answer.empty? or answer == "y"
        @interface.clear
      end
    end
  end
  
  def cmd_hook_train_wagon
    loop do
      begin
        @interface.show_trains(@railroad.trains)
        @interface.prompt_train_to_hook_wagon
        train = select_loop_from_array(@railroad.trains)
        raise StandardError.new("Adding wagon to train error: train is not selected") if train.nil?

        @interface.prompt_wagon_number_select
        wagon_number = @interface.enter_number
        if train.type == :passenger
          @interface.prompt_wagon_number_of_seats
          wagon_capacity = @interface.enter_number
        else
          @interface.prompt_wagon_capacity
          wagon_capacity = @interface.enter_number
        end
          
        @railroad.hook_train_wagon(train, wagon_number, wagon_capacity)
        break
      rescue StandardError => e
        puts e.message
        @interface.prompt_retry_command("Добавить вагон к поезду")
        answer = @interface.enter_string
        break unless answer.empty? or answer == "y"
        @interface.clear
      end
    end
  end

  def cmd_unhook_train_wagon
    loop do
      begin
        @interface.show_trains(@railroad.trains)
        @interface.prompt_train_to_unhook_wagon
        train = select_loop_from_array(@railroad.trains)
        raise StandardError.new("Unhooking wagon from train error: train is not selected") if train.nil?

        @interface.prompt_wagon_number_select
        wagon_number = @interface.enter_number
        @railroad.unhook_train_wagon(train, wagon_number)
        break
      rescue StandardError => e
        puts e.message
        @interface.prompt_retry_command("Отцепить вагон от поезда")
        answer = @interface.enter_string
        break unless answer.empty? or answer == "y"
        @interface.clear
      end
    end
  end

  def cmd_occupy_seat_in_wagon
    loop do
      begin
        @interface.show_trains(@railroad.trains)
        @interface.prompt_train_select
        train = select_loop_from_array(@railroad.trains)
        raise StandardError.new("Occupying seat in a wagon error: train is not selected") if train.nil?

        @interface.prompt_wagon_number_select
        wagon = select_loop_from_array(train.wagons)
        if wagon.type == :passenger
          @railroad.occupy_seat_in_wagon(wagon, nil)
        else
          @interface.prompt_capacity_occupy_select
          capacity_occupy = @interface.enter_number
          @railroad.occupy_seat_in_wagon(wagon, capacity_occupy)
        end
        break
      rescue StandardError => e
        puts e.message
        @interface.prompt_retry_command("Занять место в вагоне")
        answer = @interface.enter_string
        break unless answer.empty? or answer == "y"
        @interface.clear
      end
    end
  end

  def cmd_free_seat_in_wagon
    loop do
      begin
        @interface.show_trains(@railroad.trains)
        @interface.prompt_train_to_unhook_wagon
        train = select_loop_from_array(@railroad.trains)
        raise StandardError.new("Occupying seat in a wagon error: train is not selected") if train.nil?

        @interface.prompt_wagon_number_select
        wagon = select_loop_from_array(train.wagons)
        if wagon.type == :passenger
          @railroad.free_seat_in_wagon(wagon, nil)
        else
          @interface.prompt_capacity_free_select
          capacity_occupy = @interface.enter_number
          @railroad.free_seat_in_wagon(wagon, capacity_occupy)
        end
        break
      rescue StandardError => e
        puts e.message
        @interface.prompt_retry_command("Занять место в вагоне")
        answer = @interface.enter_string
        break unless answer.empty? or answer == "y"
        @interface.clear
      end
    end
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
    return if @railroad.stations.length.zero?
    
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
  
  private

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
    return unless index.positive?

    array[index - 1]
  end

  def select_loop_from_array(array)
    loop do
      index = @interface.enter_number
      return array[index - 1] if index.positive?
      raise StandardError.new("Select from array error: invalid index")
      #break if @interface.check_operation_cancel
    end
  end
end

Controller.new.run
