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
            // 외래키는 associate에서 정의되지만, 인덱스를 위해 명시적으로 추가
            userId: {
                type: DataTypes.UUID,
                allowNull: false,
                field: 'user_id',
            },
            storyId: {
                type: DataTypes.BIGINT.UNSIGNED,
                allowNull: false,
                field: 'story_id',
            },
        },
        {
            tableName: 'progress',
            timestamps: true,
            indexes: [
                {
                    unique: true,
                    fields: ['user_id', 'slot'],
                    name: 'uk_user_slot',
                },
            ],
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
            foreignKey: 'progressId',
        });
    };

    return Progress;
};