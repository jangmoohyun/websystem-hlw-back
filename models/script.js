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
            storyId: {
                type: DataTypes.BIGINT.UNSIGNED,
                allowNull: false,
                field: 'story_id',
            },
        },
        {
            tableName: 'script',
            timestamps: false,
        }
    );

    Script.associate = (models) => {
        Script.belongsTo(models.Story, {
            foreignKey: 'storyId',
            as: 'story',
        });
    };

    return Script;
};