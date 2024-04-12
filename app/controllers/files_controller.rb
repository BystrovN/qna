class FilesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def destroy
    return head :forbidden unless current_user.author_of?(file.record)

    file.purge
  end

  private

  def file
    @file ||= ActiveStorage::Attachment.find(params[:id])
  end
end
