from flask_wtf import FlaskForm
from wtforms import StringField,PasswordField,BooleanField,SubmitField
from wtforms.validators import DataRequired,Length,Email,Regexp,EqualTo
from ..models import User

class RegistrationForm(FlaskForm):
    email = StringField('邮箱', validators=[DataRequired(), Length(1, 64), Email()])
    username= StringField('用户名', validators=[DataRequired(), Length(1, 64), Regexp('^[A-Za-z][A-Za-z0-9_.]*$',0,'用户名必须是字母，数字，点号，下划线')])
    password = PasswordField('密码', validators=[DataRequired(),EqualTo('password2',message='密码不一致')])
    password2 =  PasswordField('再次输入密码', validators=[DataRequired()])
    submit = SubmitField('注册')
    def validate_email(self,filed):
        if User.query.filter_by(email=filed.data).first():
            raise ValidationError('邮箱已被注册')
    def validate_username(self,filed):
        if User.query.filter_by(username=filed.data).first():
            raise ValidationError('用户名已被使用')
            
            
https://www.cnblogs.com/Erick-L/p/6885485.html
https://github.com/Erick-LONG/flask_blog

flask-wtf 中如何让 selectField 读取的数据中选中默认项?
在render template之前使用formname.fieldname.data = 默认的选项
