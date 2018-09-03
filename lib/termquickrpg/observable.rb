module TermQuickRPG
  module Observable
    def listeners
      @listeners ||= []
    end

    def add_listener(listener)
      listeners << listener
    end

    def remove_listener(listener)
      listeners.delete(listener)
    end

    def notify_listeners(event_name, *args)
      listeners.each do |listener|
        notify_listener(listener, event_name, *args)
      end
    end

    def notify_listener(listener, event_name, *args)
      if listener.respond_to?(event_name)
        listener.public_send(event_name, self, *args)
      end
    end
  end
end
