require 'infrastructure/event'
require 'infrastructure/event_bus'
require 'infrastructure/write_repo'

module Entity
  include Wisper::Publisher

  def applied_events
    @applied_events ||= []
  end

  def apply_event(event)
    values = event.instance_values
    event_to_store = Event.new({name: event_name(event),
                                aggregate_uid: values.delete('aggregate_uid'),
                                data: values })
    do_apply event
    applied_events << event_to_store
  end

  def commit
    applied_events.each do |event|
      save_in_write_repo event
      publish event
    end
  end

  # @api private
  def do_apply(event)
    method_name = "on_#{event_name(event)}"
    method(method_name).call(event)
  end

  def save_in_write_repo(event)
    WriteRepo::add_event(event)
  end

  def publish(event)
    self.subscribe(::EventBus.handler(event.name))
    broadcast(event.name, event)
  end

  def event_name(event)
    "#{event.class.name.underscore}".sub(/_event/, '')
  end
end
