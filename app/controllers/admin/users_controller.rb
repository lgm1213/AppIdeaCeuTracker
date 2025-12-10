module Admin
  class UsersController < ApplicationController
    # Ensure only admins can access these actions
    before_action :ensure_admin!
    before_action :set_user, only: %i[ show edit update destroy ]

    # GET /admin/users
    def index
      @users = User.all
    end

    # GET /admin/users/1
    def show
    end

    # GET /admin/users/new
    def new
      @user = User.new
    end

    # GET /admin/users/1/edit
    def edit
    end

    # POST /admin/users
    def create
      @user = User.new(admin_user_params)

      # Allow setting admin/role only when the current_user is an admin
      if current_user&.respond_to?(:admin?) && current_user.admin?
        if params[:user].key?(:admin)
          @user.admin = ActiveModel::Type::Boolean.new.cast(params[:user][:admin])
        end
        @user.role = params[:user][:role] if params[:user].key?(:role)
      end

      respond_to do |format|
        if @user.save
          format.html { redirect_to admin_user_path(@user), notice: "User was successfully created." }
          format.json { render :show, status: :created, location: @user }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      # Only allow admin/role changes from an admin
      if current_user&.respond_to?(:admin?) && current_user.admin?
        # copy permitted params and then set admin/role from raw params
        permitted = admin_user_params.to_h
        permitted["admin"] = ActiveModel::Type::Boolean.new.cast(params[:user][:admin]) if params[:user].key?(:admin)
        permitted["role"]  = params[:user][:role] if params[:user].key?(:role)

        respond_to do |format|
          if @user.update(permitted)
            format.html { redirect_to admin_user_path(@user), notice: "User was successfully updated." }
            format.json { render :show, status: :ok, location: @user }
          else
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @user.errors, status: :unprocessable_entity }
          end
        end
      else
        # Non-admins can only update permitted safe attributes
        respond_to do |format|
          if @user.update(admin_user_params)
            format.html { redirect_to admin_user_path(@user), notice: "User was successfully updated." }
            format.json { render :show, status: :ok, location: @user }
          else
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @user.errors, status: :unprocessable_entity }
          end
        end
      end
    end

    # DELETE /admin/users/1
    def destroy
      @user.destroy!

      respond_to do |format|
        format.html { redirect_to admin_users_path, notice: "User was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    private
      def set_user
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        respond_to do |format|
          format.html { redirect_to admin_users_path, alert: "User not found" }
          format.json { render json: { error: "User not found" }, status: :not_found }
        end
      end

      # Strong parameters for Admin
      def admin_user_params
        params.fetch(:user, {}).permit(:email_address, :password, :password_confirmation, :name, :role)
      end

      # Security check
      def ensure_admin!
        return redirect_unauthorized unless current_user

        is_admin = if current_user.respond_to?(:admin?)
                     current_user.admin?
        elsif current_user.respond_to?(:role)
                     current_user.role == "admin"
        else
                     false
        end

        unless is_admin
          respond_to do |format|
            format.html { redirect_to root_path, alert: "Access Denied: Admins only" }
            format.json { render json: { error: "Access Denied" }, status: :forbidden }
          end
        end
      end

      def redirect_unauthorized
        respond_to do |format|
          format.html { redirect_to root_path, alert: "Please log in to access this page" }
          format.json { render json: { error: "Unauthorized" }, status: :unauthorized }
        end
      end

      def current_user
        super rescue nil
      end
  end
end
