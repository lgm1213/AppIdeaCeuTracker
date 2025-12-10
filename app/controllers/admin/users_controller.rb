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
      # The admin_user_params method now handles the conditional logic for role/admin
      @user = User.new(admin_user_params)

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

    # PATCH/PUT /admin/users/1
    def update
      respond_to do |format|
        # We use admin_user_params here as well to ensure security rules apply to updates
        if @user.update(admin_user_params)
          format.html { redirect_to admin_user_path(@user), notice: "User was successfully updated." }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
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

      # Strong parameters for Admin (Dynamic/Conditional)
      def admin_user_params
        permitted = [ :email_address, :password, :password_confirmation, :name ]
        if current_user&.respond_to?(:admin?) && current_user.admin?
          permitted += [ :role, :admin ]
        end

        if params.key?(:user)
          params.require(:user).permit(*permitted)
        else
          # If params is already an ActionController::Parameters, permit directly.
          # Otherwise wrap the plain Hash in ActionController::Parameters so permit is available.
          if params.respond_to?(:permit)
            params.permit(*permitted)
          else
            ActionController::Parameters.new(params).permit(*permitted)
          end
        end
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
