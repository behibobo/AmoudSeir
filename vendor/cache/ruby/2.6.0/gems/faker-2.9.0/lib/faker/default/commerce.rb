# frozen_string_literal: true

module Faker
  class Commerce < Base
    class << self
      def color
        fetch('color.name')
      end

      def promotion_code(legacy_digits = NOT_GIVEN, digits: 6)
        warn_for_deprecated_arguments do |keywords|
          keywords << :digits if legacy_digits != NOT_GIVEN
        end

        [
          fetch('commerce.promotion_code.adjective'),
          fetch('commerce.promotion_code.noun'),
          Faker::Number.number(digits: digits)
        ].join
      end

      def department(legacy_max = NOT_GIVEN, legacy_fixed_amount = NOT_GIVEN, max: 3, fixed_amount: false)
        warn_for_deprecated_arguments do |keywords|
          keywords << :max if legacy_max != NOT_GIVEN
          keywords << :fixed_amount if legacy_fixed_amount != NOT_GIVEN
        end

        num = max if fixed_amount
        num ||= 1 + rand(max)

        categories = categories(num)

        return merge_categories(categories) if num > 1

        categories[0]
      end

      def product_name
        "#{fetch('commerce.product_name.adjective')} #{fetch('commerce.product_name.material')} #{fetch('commerce.product_name.product')}"
      end

      def material
        fetch('commerce.product_name.material')
      end

      def price(legacy_range = NOT_GIVEN, legacy_as_string = NOT_GIVEN, range: 0..100.0, as_string: false)
        warn_for_deprecated_arguments do |keywords|
          keywords << :range if legacy_range != NOT_GIVEN
          keywords << :as_string if legacy_as_string != NOT_GIVEN
        end

        price = (rand(range) * 100).floor / 100.0
        if as_string
          price_parts = price.to_s.split('.')
          price = price_parts[0] + '.' + price_parts[-1].ljust(2, '0')
        end
        price
      end

      private

      def categories(num)
        categories = []
        while categories.length < num
          category = fetch('commerce.department')
          categories << category unless categories.include?(category)
        end

        categories
      end

      def merge_categories(categories)
        separator = fetch('separator')
        comma_separated = categories.slice!(0...-1).join(', ')

        [comma_separated, categories[0]].join(separator)
      end
    end
  end
end
