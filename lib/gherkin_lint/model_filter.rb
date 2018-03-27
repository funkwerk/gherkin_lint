module GherkinLint
  # Mixin to filter scenario models during the linting process
  module ModelFilter
    private

    def filter_guarded_models
      @files.each_value do |file_model|
        filter_feature_model(file_model, "@disable#{name}")
      end
    end

    def filter_feature_model(file_model, linter_tag_to_filter)
      feature_model = file_model.feature

      return unless feature_model

      if feature_model.tags.map(&:name).include?(linter_tag_to_filter)
        file_model.feature = nil
      else
        filter_scenario_models(feature_model, linter_tag_to_filter)
        filter_outline_models(feature_model, linter_tag_to_filter)
      end
    end

    def filter_scenario_models(feature_model, linter_tag_to_filter)
      feature_model.tests.delete_if do |test_model|
        test_model.is_a?(CukeModeler::Scenario) && test_model.tags.map(&:name).include?(linter_tag_to_filter)
      end
    end

    def filter_outline_models(feature_model, linter_tag_to_filter)
      feature_model.tests.delete_if do |test_model|
        test_model.is_a?(CukeModeler::Outline) && test_model.tags.map(&:name).include?(linter_tag_to_filter)
      end

      feature_model.outlines.each do |outline_model|
        filter_example_models(outline_model, linter_tag_to_filter)
      end
    end

    def filter_example_models(outline_model, linter_tag_to_filter)
      outline_model.examples.delete_if do |example_model|
        example_model.tags.map(&:name).include?(linter_tag_to_filter)
      end
    end
  end
end
