export default (sequelize, DataTypes) => {
    const Progress = sequelize.define(
        'Progress',
        {
            id: {
                type: DataTypes.NUMBER,
                autoIncrement: true,
                primaryKey: true,
            },
            pLike: {
                type: DataTypes.NUMBER,
                allowNull: false,
            },
            cLike: {
                type: DataTypes.NUMBER,
                allowNull: false,
            },
            jLike: {
                type: DataTypes.NUMBER,
                allowNull: false,
            },
        },
        {
            tableName: 'progresses',
            timestamps: true,
        }
    );

    // 연관관계 설정
    Progress.associate = (models) => {
        Progress.belongsTo(models.User, { foreignKey: 'userId', onDelete: 'CASCADE' });
    };

    return Progress;
};