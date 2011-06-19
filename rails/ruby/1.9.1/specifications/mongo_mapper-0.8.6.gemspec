# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{mongo_mapper}
  s.version = "0.8.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Nunemaker"]
  s.date = %q{2010-10-11}
  s.default_executable = %q{mmconsole}
  s.email = ["nunemaker@gmail.com"]
  s.executables = ["mmconsole"]
  s.files = ["bin/mmconsole", "examples/attr_accessible.rb", "examples/attr_protected.rb", "examples/cache_key.rb", "examples/custom_types.rb", "examples/identity_map/automatic.rb", "examples/identity_map/middleware.rb", "examples/identity_map.rb", "examples/keys.rb", "examples/modifiers/set.rb", "examples/plugins.rb", "examples/querying.rb", "examples/scopes.rb", "examples/validating/embedded_docs.rb", "lib/mongo_mapper/connection.rb", "lib/mongo_mapper/document.rb", "lib/mongo_mapper/embedded_document.rb", "lib/mongo_mapper/exceptions.rb", "lib/mongo_mapper/extensions/array.rb", "lib/mongo_mapper/extensions/binary.rb", "lib/mongo_mapper/extensions/boolean.rb", "lib/mongo_mapper/extensions/date.rb", "lib/mongo_mapper/extensions/float.rb", "lib/mongo_mapper/extensions/hash.rb", "lib/mongo_mapper/extensions/integer.rb", "lib/mongo_mapper/extensions/kernel.rb", "lib/mongo_mapper/extensions/nil_class.rb", "lib/mongo_mapper/extensions/object.rb", "lib/mongo_mapper/extensions/object_id.rb", "lib/mongo_mapper/extensions/set.rb", "lib/mongo_mapper/extensions/string.rb", "lib/mongo_mapper/extensions/time.rb", "lib/mongo_mapper/plugins/accessible.rb", "lib/mongo_mapper/plugins/associations/base.rb", "lib/mongo_mapper/plugins/associations/belongs_to_polymorphic_proxy.rb", "lib/mongo_mapper/plugins/associations/belongs_to_proxy.rb", "lib/mongo_mapper/plugins/associations/collection.rb", "lib/mongo_mapper/plugins/associations/embedded_collection.rb", "lib/mongo_mapper/plugins/associations/in_array_proxy.rb", "lib/mongo_mapper/plugins/associations/many_documents_as_proxy.rb", "lib/mongo_mapper/plugins/associations/many_documents_proxy.rb", "lib/mongo_mapper/plugins/associations/many_embedded_polymorphic_proxy.rb", "lib/mongo_mapper/plugins/associations/many_embedded_proxy.rb", "lib/mongo_mapper/plugins/associations/many_polymorphic_proxy.rb", "lib/mongo_mapper/plugins/associations/one_embedded_proxy.rb", "lib/mongo_mapper/plugins/associations/one_proxy.rb", "lib/mongo_mapper/plugins/associations/proxy.rb", "lib/mongo_mapper/plugins/associations.rb", "lib/mongo_mapper/plugins/caching.rb", "lib/mongo_mapper/plugins/callbacks.rb", "lib/mongo_mapper/plugins/clone.rb", "lib/mongo_mapper/plugins/descendants.rb", "lib/mongo_mapper/plugins/dirty.rb", "lib/mongo_mapper/plugins/document.rb", "lib/mongo_mapper/plugins/dynamic_querying/dynamic_finder.rb", "lib/mongo_mapper/plugins/dynamic_querying.rb", "lib/mongo_mapper/plugins/embedded_document.rb", "lib/mongo_mapper/plugins/equality.rb", "lib/mongo_mapper/plugins/identity_map.rb", "lib/mongo_mapper/plugins/indexes.rb", "lib/mongo_mapper/plugins/inspect.rb", "lib/mongo_mapper/plugins/keys/key.rb", "lib/mongo_mapper/plugins/keys.rb", "lib/mongo_mapper/plugins/logger.rb", "lib/mongo_mapper/plugins/modifiers.rb", "lib/mongo_mapper/plugins/pagination.rb", "lib/mongo_mapper/plugins/persistence.rb", "lib/mongo_mapper/plugins/protected.rb", "lib/mongo_mapper/plugins/querying/decorator.rb", "lib/mongo_mapper/plugins/querying/plucky_methods.rb", "lib/mongo_mapper/plugins/querying.rb", "lib/mongo_mapper/plugins/rails.rb", "lib/mongo_mapper/plugins/safe.rb", "lib/mongo_mapper/plugins/sci.rb", "lib/mongo_mapper/plugins/scopes.rb", "lib/mongo_mapper/plugins/serialization.rb", "lib/mongo_mapper/plugins/timestamps.rb", "lib/mongo_mapper/plugins/userstamps.rb", "lib/mongo_mapper/plugins/validations.rb", "lib/mongo_mapper/plugins.rb", "lib/mongo_mapper/support/descendant_appends.rb", "lib/mongo_mapper/version.rb", "lib/mongo_mapper.rb", "rails/init.rb", "test/_NOTE_ON_TESTING", "test/functional/associations/test_belongs_to_polymorphic_proxy.rb", "test/functional/associations/test_belongs_to_proxy.rb", "test/functional/associations/test_in_array_proxy.rb", "test/functional/associations/test_many_documents_as_proxy.rb", "test/functional/associations/test_many_documents_proxy.rb", "test/functional/associations/test_many_embedded_polymorphic_proxy.rb", "test/functional/associations/test_many_embedded_proxy.rb", "test/functional/associations/test_many_polymorphic_proxy.rb", "test/functional/associations/test_one_embedded_proxy.rb", "test/functional/associations/test_one_proxy.rb", "test/functional/test_accessible.rb", "test/functional/test_associations.rb", "test/functional/test_binary.rb", "test/functional/test_caching.rb", "test/functional/test_callbacks.rb", "test/functional/test_dirty.rb", "test/functional/test_document.rb", "test/functional/test_dynamic_querying.rb", "test/functional/test_embedded_document.rb", "test/functional/test_identity_map.rb", "test/functional/test_indexes.rb", "test/functional/test_logger.rb", "test/functional/test_modifiers.rb", "test/functional/test_pagination.rb", "test/functional/test_protected.rb", "test/functional/test_querying.rb", "test/functional/test_safe.rb", "test/functional/test_sci.rb", "test/functional/test_scopes.rb", "test/functional/test_string_id_compatibility.rb", "test/functional/test_timestamps.rb", "test/functional/test_userstamps.rb", "test/functional/test_validations.rb", "test/models.rb", "test/test_active_model_lint.rb", "test/test_helper.rb", "test/unit/associations/test_base.rb", "test/unit/associations/test_proxy.rb", "test/unit/serializers/test_json_serializer.rb", "test/unit/test_clone.rb", "test/unit/test_descendant_appends.rb", "test/unit/test_document.rb", "test/unit/test_dynamic_finder.rb", "test/unit/test_embedded_document.rb", "test/unit/test_extensions.rb", "test/unit/test_key.rb", "test/unit/test_keys.rb", "test/unit/test_mongo_mapper.rb", "test/unit/test_pagination.rb", "test/unit/test_plugins.rb", "test/unit/test_rails.rb", "test/unit/test_rails_compatibility.rb", "test/unit/test_serialization.rb", "test/unit/test_time_zones.rb", "test/unit/test_validations.rb", "LICENSE", "UPGRADES", "README.rdoc"]
  s.homepage = %q{http://github.com/jnunemaker/mongomapper}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A Ruby Object Mapper for Mongo}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 2.3.4"])
      s.add_runtime_dependency(%q<jnunemaker-validatable>, ["~> 1.8.4"])
      s.add_runtime_dependency(%q<plucky>, ["~> 0.3.6"])
      s.add_development_dependency(%q<json>, [">= 0"])
      s.add_development_dependency(%q<log_buddy>, [">= 0"])
      s.add_development_dependency(%q<jnunemaker-matchy>, ["~> 0.4.0"])
      s.add_development_dependency(%q<shoulda>, ["~> 2.11"])
      s.add_development_dependency(%q<timecop>, ["~> 0.3.1"])
      s.add_development_dependency(%q<mocha>, ["~> 0.9.8"])
    else
      s.add_dependency(%q<activesupport>, [">= 2.3.4"])
      s.add_dependency(%q<jnunemaker-validatable>, ["~> 1.8.4"])
      s.add_dependency(%q<plucky>, ["~> 0.3.6"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<log_buddy>, [">= 0"])
      s.add_dependency(%q<jnunemaker-matchy>, ["~> 0.4.0"])
      s.add_dependency(%q<shoulda>, ["~> 2.11"])
      s.add_dependency(%q<timecop>, ["~> 0.3.1"])
      s.add_dependency(%q<mocha>, ["~> 0.9.8"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 2.3.4"])
    s.add_dependency(%q<jnunemaker-validatable>, ["~> 1.8.4"])
    s.add_dependency(%q<plucky>, ["~> 0.3.6"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<log_buddy>, [">= 0"])
    s.add_dependency(%q<jnunemaker-matchy>, ["~> 0.4.0"])
    s.add_dependency(%q<shoulda>, ["~> 2.11"])
    s.add_dependency(%q<timecop>, ["~> 0.3.1"])
    s.add_dependency(%q<mocha>, ["~> 0.9.8"])
  end
end
