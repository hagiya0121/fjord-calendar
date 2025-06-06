# frozen_string_literal: true

class EntriesController < ApplicationController
  before_action :set_entry, only: %i[edit update destroy]
  before_action :require_owner!, except: %i[new create]
  before_action :current_calendar, only: %i[new create]

  def new
    @entry = Entry.new(calendar: @current_calendar, registration_date: params[:registration_date])
  end

  def edit; end

  def create
    @entry = current_user.entries.new(entry_params.merge(calendar: @current_calendar))

    ActiveRecord::Base.transaction do
      @entry.save!
      @entry.update_meta_info!
    end

    flash.now[:notice] = '記事を登録しました'
    render :create, locals: { entry: @entry }
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_entity
  end

  def update
    ActiveRecord::Base.transaction do
      @entry.update!(entry_params)
      @entry.update_meta_info!
    end

    flash.now[:notice] = '記事を更新しました'
    render :update, locals: { entry: @entry }
  rescue ActiveRecord::RecordInvalid
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @entry.destroy
    flash.now[:notice] = '記事を削除しました'
    render :destroy, locals: { entry: @entry }
  end

  private

  def set_entry
    @entry = Entry.find(params[:id])
  end

  def entry_params
    params.expect(entry: %i[title url registration_date])
  end

  def require_owner!
    return if @entry.user == current_user || current_user.role == 'admin'

    redirect_to root_path, alert: 'アクセス権限がありません'
  end

  def current_calendar
    @current_calendar = Calendar.find_by!(year: params[:calendar_year])
  end
end
