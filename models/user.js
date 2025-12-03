export default (sequelize, DataTypes) => {
    const User = sequelize.define(
        'User',
        {
            id: {
                type: DataTypes.UUID,
                allowNull: false,
                primaryKey: true,
                defaultValue: DataTypes.UUIDV4,
            },
            email: {
                type: DataTypes.STRING(100),
                allowNull: false,
                unique: true,
            },
            password: {
                type: DataTypes.STRING(255),
                allowNull: true,
            },
            nickname: {
                type: DataTypes.STRING(30),
                unique: true,
            },
            snsId: {
                type: DataTypes.STRING(100),
                allowNull: true,
            },
            provider: {
                type: DataTypes.STRING(20),
                allowNull: true,
            },
            refreshToken: {
                type: DataTypes.TEXT,
                allowNull: true,
            },
        },
        {
            tableName: 'users',
            timestamps: true, // createdAt, updatedAt 직접 정의했으면 자동 컬럼 끄기(false)
        }
    );

    // 연관관계 설정
    User.associate = (models) => {
        User.hasMany(models.Progress, {
            as: 'progresses',
            foreignKey: 'user_id',
            onDelete: 'CASCADE',
        });
    };

    return User;
};