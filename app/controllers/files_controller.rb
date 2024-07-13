class FilesController < ApplicationController
  authorize_resource

  def destroy
    file.purge
  end

  private

  def file
    @file ||= ActiveStorage::Attachment.find(params[:id])
  end
end
