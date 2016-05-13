# encoding: utf-8
module Searchable

	extend ActiveSupport::Concern

	module Term

		def self.explicit? term
			term[0] == '!'
		end

		def self.exclusive? term
			term[0] == '-'
		end

		def self.inclusive? term
			term[0] == '+'
		end

		def self.clean term
			if self.exclusive?(term) || self.inclusive?(term) || self.explicit?(term)
				term = term[1..-1]
			end
			term.squish.downcase
		end

		def self.to_query *terms
			statements = []
			terms.each_with_index do |term, index|
				if self.explicit?(term)
					statements.push ["AND", "LOWER(%{column})", "NOT LIKE :term__#{index + 1}"]
				elsif self.exclusive?(term)
					statements.push ["OR", "LOWER(%{column})", "NOT LIKE :term__#{index + 1}"]
				elsif self.inclusive?(term)
					statements.push ["AND", "LOWER(%{column})", "LIKE :term__#{index + 1}"]
				else
					statements.push ["OR", "LOWER(%{column})", "LIKE :term__#{index + 1}"]
				end
			end
			statement = statements.join ' '
			statement.sub(/^(AND|OR)/, '').squish
		end

		def self.to_query_column column, *terms
			self.to_query(*terms) % { column: column }
		end

	end

	module ClassMethods

		def searchable_through *columns
			@searchables ||= {}
			@searchables[self.to_s] = columns
		end

		def search *terms
			if terms && @searchables.present?
				statements = []
				variables = {}
				@searchables[self.to_s].each do |column|
					statements.push "(#{Term.to_query_column(column, *terms)})"
				end
				terms.each_with_index do |term, index|
					variables["term__#{index + 1}".to_sym] = "%#{Term.clean(term)}%"
				end
				where(statements.join(' OR '), variables)
			else
				none
			end
		end

		def search_by column, *terms
			if terms
				variables = {}
				terms.each_with_index do |term, index|
					variables["term__#{index + 1}".to_sym] = "%#{Term.clean(term)}%"
				end
				where(Term.to_query_column(column, *terms), variables)
			else
				none
			end
		end

	end

end
