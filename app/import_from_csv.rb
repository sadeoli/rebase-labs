#Dica 1: primeiramente, separar o código que busca os dados em uma classe Ruby separada, pois além de ser mais fácil para testar, facilita o refactoring para quando fizermos a leitura direto do database SQL
require 'csv'
require 'pg'

class ImportCSV < Sinatra::Base
  
  def initialize
    @conn = PG.connect(host: 'postgres', dbname: 'postgres', user: 'postgres')
  end

  def all
    create_table
    insert_data
    return @conn.exec("SELECT * FROM tests").to_a
  end

  def create_table
    @conn.exec("DROP TABLE IF EXISTS TESTS")
    @conn.exec("
              CREATE TABLE TESTS (
              id SERIAL PRIMARY KEY,
              cpf VARCHAR(24) NOT NULL,
              name VARCHAR NOT NULL,
              email VARCHAR NOT NULL,
              birthday DATE NOT NULL,
              address VARCHAR NOT NULL,
              city VARCHAR NOT NULL,
              state VARCHAR NOT NULL,
              doctor_crm VARCHAR NOT NULL,
              doctor_crm_state VARCHAR(2) NOT NULL,
              doctor_name VARCHAR NOT NULL,
              doctor_email VARCHAR NOT NULL,
              test_type VARCHAR NOT NULL,
              test_limits VARCHAR NOT NULL,
              test_result VARCHAR NOT NULL,
              result_token VARCHAR(6) NOT NULL,
              result_date DATE NOT NULL)
             ")
  end

  def insert_data
    csv_to_hash.each do |test|
      @conn.exec(
        "INSERT INTO TESTS (cpf, name, email, birthday, address, city, state, 
          doctor_crm, doctor_crm_state, doctor_name, doctor_email, 
          test_type , test_limits, test_result, result_token, result_date)
          VALUES ('#{test['cpf']}', '#{test['nome paciente']}', '#{test['email paciente']}', 
                  '#{test['data nascimento paciente']}', '#{test['endereço/rua paciente']}',
                  '#{@conn.escape_string(test['cidade paciente'])}', '#{test['estado patiente']}',
                  '#{test['crm médico']}', '#{test['crm médico estado']}',
                  '#{test['nome médico']}', '#{test['email médico']}',
                  '#{test['tipo exame']}', '#{test['limites tipo exame']}', #{test['resultado tipo exame'].to_i},
                  '#{test['token resultado exame']}', '#{test['data exame']}')"
      ) 
    end
  end


  def csv_to_hash
    rows = CSV.read("./data.csv", col_sep: ';')

    columns = rows.shift
  
    rows.map do |row|
      row.each_with_object({}).with_index do |(cell, acc), idx|
        column = columns[idx]
        acc[column] = cell
      end
    end
  end
end