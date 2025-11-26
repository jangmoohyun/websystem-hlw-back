export default (sequelize, DataTypes) => {
    const Story = sequelize.define(
        'Story',
        {
            id: {
                type: DataTypes.BIGINT.UNSIGNED,
                primaryKey: true,
                autoIncrement: true,
            },
            title: {
                type: DataTypes.STRING(255),
                allowNull: false,
                comment: '장 제목',
            },
            content: {
                type: DataTypes.TEXT,
                allowNull: true,
                comment: '장 내용 / 설명',
            },
            image: {
                type: DataTypes.STRING(500),
                allowNull: true,
                comment: '배경 이미지 URL',
            },
        },
        {
            tableName: 'story',
            timestamps: false,
        }
    );

    Story.associate = (models) => {
        Story.hasOne(models.Script, {
            as: 'script',
            foreignKey: 'storyId',
        });

        Story.hasMany(models.Progress, {
            as: 'progresses',
            foreignKey: 'storyId',
        });
    };

    return Story;
};