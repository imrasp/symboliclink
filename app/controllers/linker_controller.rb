class LinkerController < ApplicationController
  skip_before_action :verify_authenticity_token
  require 'json'

  def link_folder
    # TO TEST THIS FUNCTION RUN
    # curl -X POST -H "Content-Type: application/json" -d '{"folder_location": "public/slides","folder_name": "misc"}' localhost:3000/linker

    # create symbolic link from folder to folder
    # input : folder location, folder name
    # output: link success
    #         link failed - file not exist
    #         link failed - cannot find destination folder
    #         link failed -

    # initial parameter : destination_location (paperclips image location)
    desination_location = 'public/test_sym_ori'
    # if File.exist?(desination_location)
    #   puts "destination exist"
    # end

    data_hash = JSON.parse(request.body.read)
    puts data_hash['folder_location']
    puts data_hash['folder_name']

    respond_to do |format|
      if File.exist?(data_hash['folder_location'])
        puts "client mount folder is exist"

        if File.exist?(desination_location + "/" + data_hash['folder_name'])
          puts "image folder in client mount folder is exist"
          format.json {render json: {:status => "Failed! - image folder in master file system is exist"}}

        elsif File.symlink?(desination_location + "/" + data_hash['folder_name'])
          puts "image symbolic folder in client mount folder is exist"
          format.json {render json: {:status => "Failed! - image symbolic folder in master file system is exist"}}

        else
          puts "create symbolic link"
          File.symlink(data_hash['folder_location'] + "/" + data_hash['folder_name'], desination_location + "/" + data_hash['folder_name'])
          format.json {render json: {:status => "Success!"}}

        end
      else
        puts "client mount folder does not exist"
        format.json {render json: {:status => "Failed! - client mount folder does not exist"}}
      end

    end
  end
end
