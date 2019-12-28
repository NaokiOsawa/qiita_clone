class Api::V1::ApiController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
end
