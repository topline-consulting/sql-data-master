desc "Price Update"

task :price_update => :environment do

  Rails.logger.info "Price update background task started"

  @salestax = Chart.find_by_accno(ACCOUNTING["salestax"].to_s).id
  @manufacturer = ENV["MANUFACTURER"].to_s
  Rails.logger.info "Manufacturer: " + @manufacturer.to_s
  @markup = ENV["MARKUP"].to_f / 100  
  Rails.logger.info "Markup: " + @markup.to_s
  @total_records = 0
  @total_created = 0
  @total_updated = 0
  @total_errors = 0
    
  Rails.logger.info "Loading price configuration for manufacturer"
  begin
    CONFIG = YAML.load_file("config/#{@manufacturer.to_s}.yml")
  rescue
    Rails.logger.info "Unable to load configuration for manufacturer: " + @manufacturer.to_s
  end
  
  if CONFIG["format"] == 'FIXEDLENGTH' 
    Rails.logger.info "Processing fixed length file"
  
    @pricefile = File.open(ENV["PRICEFILE"], 'r')
    
      @pricefile.each {|currentline|
      
        currentline.gsub!('"', ' ')
        
        @total_records += 1 
        
        if CONFIG["header_rows"].to_i < @total_records
        
          part_in = currentline.slice(CONFIG["partnumber"]["offset"], CONFIG["partnumber"]["length"]).strip
          
          newpart = false
          if @part = Part.find_by_partnumber(part_in.to_s)
            @total_updated += 1
            @part.send "set_id", @part.id
          else
            @part = Part.new
            @total_created += 1
            newpart = true
          end
          
          @part.send "set_partnumber", part_in

          begin
          price_in = currentline.slice(CONFIG["listprice"]["offset"], CONFIG["listprice"]["length"]).strip
          @part.send "set_listprice", price_in
          rescue
          end
          
          begin
          cost_in = currentline.slice(CONFIG["cost"]["offset"], CONFIG["cost"]["length"]).strip
          @part.send "set_lastcost", cost_in
          rescue
          end
          
          begin
          description_in = currentline.slice(CONFIG["description"]["offset"], CONFIG["description"]["length"]).strip
          @part.send "set_description", description_in
          rescue
          end
          
          begin
          notes_in = currentline.slice(CONFIG["notes"]["offset"], CONFIG["notes"]["length"]).strip
          @part.send "set_toolnumber", notes_in
          rescue
          end
          
          begin
          if @part.listprice && @markup
            @part.sellprice = @part.listprice + (@part.listprice * @markup)
            @part.send "set_sellprice", @part.sellprice 
          end
          rescue
          end
          
          if @part.partnumber
            @part.save!
            if newpart
              Part.find_by_sql("insert into makemodel values ('" + @part.id.to_s + "','" + @manufacturer + "');")
              Part.find_by_sql("insert into partstax values ('" + @part.id.to_s + "','" + @salestax.to_s + "');")
            end
          else
            @total_errors += 1
          end
          
        end 
      }
  
  elsif CONFIG["format"] == 'DELIMITED'
    Rails.logger.info "Processing delimited file"
      
    require 'csv'

    CSV.open(ENV["PRICEFILE"], 'r').each do |row|
    
      row.inspect
     
      @total_records += 1
      
      if CONFIG["header_rows"] < @total_records
        
        newpart = false
        partnumber = row[CONFIG["partnumber"]["column"].to_i - 1].to_s
        Rails.logger.info 'Processing incoming part ' + partnumber
        if @part = Part.find_by_partnumber(partnumber)
          Rails.logger.info 'Part located in database'
          @total_updated += 1
        else
          Rails.logger.info 'New part creation started'
          @part = Part.new
          @part.send "set_partnumber", partnumber
          @part.partnumber = partnumber
          @total_created += 1
          newpart = true
        end
        
        current_cell = 0
        row.each { |cell| 
          current_cell += 1
          listprice = 0.0
          sellprice = 0.0
          #Rails.logger.info 'Processing cell ' + current_cell.to_s + ' value = ' + cell.to_s
          
          if CONFIG["listprice"]["column"] == current_cell
            Rails.logger.info "Decimals: " + CONFIG["includes_decimals"].to_s
            if CONFIG["includes_decimals"] == true
              listprice = cell.delete('$,').to_f
            else
              listprice = cell.delete('$,').to_f / 100
            end
            Rails.logger.info 'List price set to ' + listprice.to_s
            #if @part.listprice # && @markup
              sellprice = listprice + ( listprice * @markup.to_f )
              Rails.logger.info 'Sell price set to ' + sellprice.to_s + ' markup ' + @markup.to_s
              @part.send "set_sellprice", sellprice
            #end              
            @part.send "set_listprice", listprice
          elsif CONFIG["cost"]["column"] == current_cell
            Rails.logger.info 'Cost set to ' + cell.to_s
            if CONFIG["includes_decimals"] == true
              @part.lastcost = cell.delete('$,').to_f
            else
              @part.lastcost = cell.delete('$,').to_f / 100
            end              
            @part.send "set_lastcost", cell
          elsif CONFIG["description"]["column"] == current_cell
            Rails.logger.info 'Description set to ' + cell.to_s
            @part.send "set_description", cell
          elsif CONFIG["notes"]["column"] == current_cell
            Rails.logger.info 'Notes set to ' + cell.to_s
            @part.send "set_toolnumber", cell            
          else
            #Rails.logger.info 'Cell not relevant for price update'
          end
          
        }
        
        begin
          Rails.logger.info "Trying to save part to database"
          @part.save!
          Rails.logger.info "Save occurred"
          if newpart
            Rails.logger.info "Adding make/model and tax entries to database"
            Part.find_by_sql("insert into makemodel values ('" + @part.id.to_s + "','" + @manufacturer + "');")
            Part.find_by_sql("insert into partstax values ('" + @part.id.to_s + "','" + @salestax + "');")
          end 
          Rails.logger.info 'Part update complete'
        rescue
          Rails.logger.info 'Problem saving part to database'
          @total_errors += 1
        end
        
      end
    end
  end
  
end
