require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ユーザー新規登録' do
    before do
      @user = build(:user)
    end


    context '登録できるとき' do
      it '全ての項目があれば登録できる' do
        expect(@user).to be_valid
      end
    end

    context '登録できないとき' do
      it 'nicknameが空では登録できない' do
        @user.nickname = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("ニックネーム を入力してください")
      end

      it 'nicknameが21文字以上では登録できない' do
        @user.nickname = 'あ' * 21
        @user.valid?
        expect(@user.errors.full_messages).to include("ニックネーム は20文字以内で入力してください")
      end

      it 'emailが空では登録できない' do
        @user.email = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("メールアドレス を入力してください")
      end

      it '重複したemailは登録できない' do
        @user.save
        another_user = build(:user, email: @user.email)
        another_user.valid?
        expect(another_user.errors.full_messages).to include("メールアドレス はすでに存在します")
      end

      it 'emailが@を含まない場合は登録できない' do
        @user.email = 'invalidemail.com'
        @user.valid?
        expect(@user.errors.full_messages).to include('メールアドレス は不正な値です')
      end

      it 'passwordが空では登録できない' do
        @user.password = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワード を入力してください")
      end

      it 'passwordが5文字以下では登録できない' do
        @user.password = '12345'
        @user.password_confirmation = '12345'
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワード は6文字以上で入力してください")
      end

      it 'passwordとpassword_confirmationが一致しないと登録できない' do
        @user.password_confirmation = 'mismatch'
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワード（確認用） と一致しません")
      end

      it 'birthdayが空では登録できない' do
        @user.birthday = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("誕生日 を入力してください")
      end
    end
  end
end

