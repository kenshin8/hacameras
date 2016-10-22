require 'net/http'
require "uri"

@cameraDelay = 1             # Needed for image sync. 
@fetchNewImageEvery = '10s'  # replace new image every 10secs, change to whatever refresh time you want
@ha_host = ""   # your hass ip
@ha_port = ""            # hass port
ha_key = ""           # hass api key

@camera1_api_url = "/api/camera_proxy/camera.name?token=1234567890&api_password=#{ha_key}"     # get your camera1 api url from hass entity page
@newFile1 = "assets/images/cameras/snapshot1_new.jpg"
@oldFile1 = "assets/images/cameras/snapshot1_old.jpg"


@camera2_api_url = "/api/camera_proxy/camera.name?token=1234567890&api_password=#{ha_key}"   # get your camera2 api url from hass entity page
@newFile2 = "assets/images/cameras/snapshot2_new.jpg"
@oldFile2 = "assets/images/cameras/snapshot2_old.jpg"


@camera3_api_url = "/api/camera_proxy/camera.name?token=1234567890&api_password=#{ha_key}"        # get your camera3 api url from hass entity page
@newFile3 = "assets/images/cameras/snapshot3_new.jpg"
@oldFile3 = "assets/images/cameras/snapshot3_old.jpg"


@camera4_api_url = "/api/camera_proxy/camera.name?token=1234567890&api_password=#{ha_key}"        # get your camera4 api url from hass entity page
@newFile4 = "assets/images/cameras/snapshot4_new.jpg"
@oldFile4 = "assets/images/cameras/snapshot4_old.jpg"

 
def fetch_image_http(host,old_file,new_file, cam_port, cam_url)
	`rm #{old_file}` 
	`mv #{new_file} #{old_file}`	
	Net::HTTP.start(host,cam_port) do |http|
		req = Net::HTTP::Get.new(cam_url)
		response = http.request(req)
		open(new_file, "wb") do |file|
			file.write(response.body)
		end
	end
	new_file
end
 
def fetch_image_https(host,old_file,new_file, cam_port, cam_url)
	`rm #{old_file}` 
	`mv #{new_file} #{old_file}`	

	uri = URI('https://...')

	Net::HTTP.start(host,cam_port,
		:use_ssl => uri.scheme == 'https',
		:verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
		req = Net::HTTP::Get.new(cam_url)
		response = http.request(req)
		open(new_file, "wb") do |file|
			file.write(response.body)
		end
	end
	new_file
end


def make_web_friendly(file)
  "/" + File.basename(File.dirname(file)) + "/" + File.basename(file)
end
 
SCHEDULER.every @fetchNewImageEvery, first_in: 0 do
	new_file1 = fetch_image_https(@ha_host,@oldFile1,@newFile1,@ha_port,@camera1_api_url)    # change fetch_image_https to fetch_image_http if you use hass without ssl
	new_file2 = fetch_image_https(@ha_host,@oldFile2,@newFile2,@ha_port,@camera2_api_url)    # change fetch_image_https to fetch_image_http if you use hass without ssl
	new_file3 = fetch_image_https(@ha_host,@oldFile3,@newFile3,@ha_port,@camera3_api_url)    # change fetch_image_https to fetch_image_http if you use hass without ssl
	new_file4 = fetch_image_https(@ha_host,@oldFile4,@newFile4,@ha_port,@camera4_api_url)    # change fetch_image_https to fetch_image_http if you use hass without ssl

	if not File::exists?(@newFile1 && @newFile2 && @newFile3 && @newFile4)              # add/remove according to the number of camera needed
		warn "Failed to Get Camera Image"
	end
 
	send_event('camera1', image: make_web_friendly(@oldFile1))
	send_event('camera2', image: make_web_friendly(@oldFile2))
	send_event('camera3', image: make_web_friendly(@oldFile3))
	send_event('camera4', image: make_web_friendly(@oldFile4))
	sleep(@cameraDelay)
	send_event('camera1', image: make_web_friendly(new_file1))
	send_event('camera2', image: make_web_friendly(new_file2))
	send_event('camera3', image: make_web_friendly(new_file3))
	send_event('camera4', image: make_web_friendly(new_file4))
end
