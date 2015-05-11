require 'lotus/utils/class_attribute'
require 'lotus/routing/resource/options'
require 'lotus/routing/resource/action'

module Lotus
  module Routing
    # Set of RESTful resource routes
    # Implementation of Lotus::Router#resource
    #
    # @since 0.1.0
    #
    # @api private
    #
    # @see Lotus::Router#resource
    class Resource
      include Utils::ClassAttribute

      # @api private
      # @since x.x.x
      NESTED_ROUTES_SEPARATOR = '/'.freeze

      # Set of default routes
      #
      # @api private
      # @since 0.1.0
      class_attribute :actions
      self.actions = [:new, :create, :show, :edit, :update, :destroy]

      # Action class
      #
      # @api private
      # @since 0.1.0
      class_attribute :action
      self.action = Resource::Action

      # Member action class
      #
      # @api private
      # @since 0.1.0
      class_attribute :member
      self.member = Resource::MemberAction

      # Collection action class
      #
      # @api private
      # @since 0.1.0
      class_attribute :collection
      self.collection = Resource::CollectionAction

      # @api private
      # @since x.x.x
      attr_reader :parent

      # @api private
      # @since 0.1.0
      def initialize(router, name, options = {}, parent = nil, &blk)
        @router  = router
        @name    = name
        @parent  = parent
        @options = Options.new(self.class.actions, options.merge(name: @name))
        generate(&blk)
      end

      # Allow nested resources inside resource or resources
      #
      # @since x.x.x
      #
      # @see Lotus::Router#resources
      def resources(name, options = {}, &blk)
        _resource(Resources, name, options, &blk)
      end

      # Allow nested resource inside resource or resources
      #
      # @since x.x.x
      #
      # @see Lotus::Router#resource
      def resource(name, options = {}, &blk)
        _resource(Resource, name, options, &blk)
      end

      # Return separator
      #
      # @api private
      # @since x.x.x
      def wildcard_param(route_param = nil)
        NESTED_ROUTES_SEPARATOR
      end

      private

      # @api private
      # @since x.x.x
      def _resource(klass, name, options, &blk)
        options = options.merge(separator: @options[:separator], namespace: @options[:namespace])
        klass.new(@router, [@name, name].join(NESTED_ROUTES_SEPARATOR), options, self, &blk)
      end

      def generate(&blk)
        instance_eval(&blk) if block_given?

        @options.actions.each do |action|
          self.class.action.generate(@router, action, @options, self)
        end
      end

      def member(&blk)
        self.class.member.new(@router, @options, self, &blk)
      end

      def collection(&blk)
        self.class.collection.new(@router, @options, self, &blk)
      end
    end
  end
end
