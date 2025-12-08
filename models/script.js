export default (sequelize, DataTypes) => {
    const Script = sequelize.define(
        'Script',
        {
            id: {
                type: DataTypes.BIGINT.UNSIGNED,
                primaryKey: true,
                autoIncrement: true,
            },
            line: {
                type: DataTypes.JSON,
                allowNull: false,
                comment: '대사/선택지 JSON',
            },
            summary: {
                type: DataTypes.STRING(255),
                allowNull: true,
                comment: '장면 설명',
            },
        },
        {
            tableName: 'script',
            timestamps: false,
        }
    );

    Script.associate = (models) => {
        Script.belongsTo(models.Story, {
            foreignKey: 'story_id',
            as: 'story',
        });
    };

    return Script;
};
