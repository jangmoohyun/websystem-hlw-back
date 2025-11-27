export default (sequelize, DataTypes) => {
    const Progress = sequelize.define(
        'Progress',
        {
            id: {
                type: DataTypes.BIGINT.UNSIGNED,
                primaryKey: true,
                autoIncrement: true,
            },
            // 세이브 슬롯 번호 (1~5)
            slot: {
                type: DataTypes.TINYINT.UNSIGNED,
                allowNull: false,
                defaultValue: 1,
            },
            // 현재 스크립트의 줄 인덱스 (0,1,2,...)
            lineIndex: {
                type: DataTypes.INTEGER.UNSIGNED,
                allowNull: false,
                defaultValue: 0,
            },
        },
        {
            tableName: 'progress',
            timestamps: true,
        }
    );

    Progress.associate = (models) => {
        Progress.belongsTo(models.User, {
            as: 'user',
            foreignKey: {
                name: 'userId',
                field: 'user_id',
                allowNull: false,
            },
            onDelete: 'CASCADE',
        });

        Progress.belongsTo(models.Story, {
            as: 'story',
            foreignKey: {
                name: 'storyId',
                field: 'story_id',
                allowNull: false,
            },
            onDelete: 'CASCADE',
        });

        Progress.hasMany(models.HeroineLike, {
            as: 'heroineLikes',
            foreignKey: 'progress_id',
        });
    };

    return Progress;
};